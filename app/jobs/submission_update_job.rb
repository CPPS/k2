class SubmissionUpdateJob < ApplicationJob
	queue_as :default

	# Update submissions
	def perform(*args)
		servers = Server.all
		stale_accounts = []
		for s in servers
			if(s.api_type != "domjudge")
				puts "Unsupported Judge Type"
				next
			end

			data = ""
			open(s.api_endpoint + "submissions?fromid=" + s.last_submission.to_s) do |f|
				data = JSON.parse(f.read)
			end

			if (data.size == 0)
				puts "No new judgings"
				next
			end

			scoreboard = ""
			open(s.api_endpoint + "scoreboard") do |f|
				scoreboard = JSON.parse(f.read)
			end
			
			for sub in data
				#submission = Submission.new
				problem = Problem.where(server_id: s.id, problem_id: sub["problem"]).first
				account = Account.where(server_id: s.id, account_id: sub["team"]).first

				submission = Submission.find_or_initialize_by(
					problem: problem,
					submission_id: sub["id"]
				)
				submission.account = account
				submission.created_at = Time.at(sub["time"].to_i).to_s(:db)
				submission.save!
				
				s.last_submission = sub["id"].to_i
			end

			for sub in data.reverse
				problem = Problem.where(server_id: s.id, problem_id: sub["problem"]).first
				account = Account.where(server_id: s.id, account_id: sub["team"]).first
				submission = Submission.find_or_initialize_by(
					problem: problem,
					submission_id: sub["id"]
				)
				#submission.submission_id = sub["id"]
				if scoreboard[sub["team"]] == nil
					submission.account_hidden!
				elsif scoreboard[sub["team"]][sub["problem"]] == nil
					submission.problem_hidden!
				else
					sbEntry = scoreboard[sub["team"]][sub["problem"]]
					break if sbEntry["num_pending"] == 0 #Prevent Race condition where DJ sends the submission but has not scored it yet
					accepted = sbEntry["is_correct"] && !Submission.accepted.where(problem: problem, account: account).where.not(submission_id: sub["id"]).exists?
					if accepted
						submission.correct!
						stale_accounts.push(submission.account)
						submission.score = sbEntry["time"].to_i + sbEntry["penalty"]
						update_solved_set(account, problem)
					else
						submission.wrong!
					end
				end

				submission.save!
			end

			s.save!

			ScoreUpdateJob.perform_later(*stale_accounts)
		end
	end

	def update_solved_set(account, problem)
		RedisPool.with { |r| r.sadd "account-#{account.id}", problem.id }
	end
end
