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
			processed_submissions = 0
			data.each do |sub|
				break if processed_submissions >= 100
				processed_submissions += 1
				problem = Problem.where(server_id: s.id, problem_id: sub["problem"]).first
				account = Account.where(server_id: s.id, account_id: sub["team"]).first

				submission = Submission.find_or_initialize_by(
					problem: problem,
					submission_id: sub["id"]
				)
				submission.account = account
				submission.created_at = Time.at(sub['time'].to_i).getutc.to_s(:db)
				submission.save!
				SubmissionStatusUpdateJob.perform_later(submission.id)
				s.last_submission = sub['id'].to_i + 1
			end

			s.save!

		end
	end
end
