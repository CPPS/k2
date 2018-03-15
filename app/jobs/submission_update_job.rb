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
			open(s.api_endpoint + "submissions?cid=#{s.contest_id}&fromid=#{s.submissions.maximum(:submission_id) + 1}&limit=100") do |f|
				data = JSON.parse(f.read)
			end

			if (data.size == 0)
				puts "No new judgings"
				next
			end

			scoreboard = ""
			open(s.api_endpoint + "scoreboard?cid=#{s.contest_id}") do |f|
				scoreboard = JSON.parse(f.read)
			end
			data.each do |sub|
				problem = Problem.where(server_id: s.id, problem_id: sub["problem"]).first
				account = Account.where(server_id: s.id, account_id: sub["team"]).first

				unless account
					account = Account.new
					account.server = s
					account.account_id = sub['team']
					account.name = "Unknown User #{sub['team']}"
					account.save!
					AccountUpdateJob.perform_now # Check if it is a real user or a system one
				end

				submission = Submission.find_or_initialize_by(
					problem: problem,
					submission_id: sub["id"]
				)
				submission.account = account
				submission.language = sub["language"]
				submission.created_at = Time.at(sub['time'].to_i).getutc.to_s(:db)
				submission.save!
				#SubmissionStatusUpdateJob.perform_later(submission.id)
			end

			s.save!

		end
	end
end
