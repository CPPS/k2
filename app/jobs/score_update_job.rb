class ScoreUpdateJob < ApplicationJob
	queue_as :default

	# Update the scores of all users 
	def perform(*accounts)
		accounts = Account.all if accounts == []

		for a in accounts
#			oldSolvedProblems = a.solvedProblems
#			oldScore = a.score
			a.solvedProblems = Submission.select(:problem_id).distinct.where(account: a, accepted: true).count

			# Ensure the score is calculated correctly in cases where a user submits two problems in one minute
			a.score = Submission.select(:problem_id, :score).distinct.where(account: a, accepted: true).pluck(:problem_id, :score).sum { |s| s[1] }
			a.save!
		end
	end
end
