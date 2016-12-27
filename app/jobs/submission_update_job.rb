class SubmissionUpdateJob < ApplicationJob
	queue_as :default

	# Update submissions
	def perform(*args)
		servers = Server.all
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
				submission = Submission.find_or_initialize_by(
					problem: problem,
					submission_id: sub["id"]
				)
				submission.account = Account.where(server_id: s.id, account_id: sub["team"]).first
				#submission.submission_id = sub["id"]
				if scoreboard[sub["team"]] == nil
					submission.accepted = false
					submission.status = "Team unknown"
				elsif scoreboard[sub["team"]][sub["problem"]] == nil
					submission.accepted = false
					submission.status = "Problem unknown"
				else
					break if scoreboard[sub["team"]][sub["problem"]]["num_pending"] == 0 #Prevent Race condition where DJ sends the submission but has not scored it yet
					accepted = scoreboard[sub["team"]][sub["problem"]]["is_correct"]
					submission.accepted = accepted
					submission.status = accepted ? "Accepted" : "Not accepted"
				end
				s.last_submission = sub["id"]
				submission.save!
			end

			s.save!
		end
	end
end
