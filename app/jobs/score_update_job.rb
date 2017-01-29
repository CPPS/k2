class ScoreUpdateJob < ApplicationJob
	queue_as :default

	# Update the scores of all users 
	def perform(*accounts)
		accounts = Account.all if accounts == []

		for a in accounts
#			oldSolvedProblems = a.solvedProblems
#			oldScore = a.score
			a.solvedProblems = Submission.accepted.select(:problem_id).distinct.where(account: a).count

			# Ensure the score is calculated correctly in cases where a user submits two problems in one minute
			a.score = Submission.accepted.select(:problem_id, :score).distinct.where(account: a).pluck(:problem_id, :score).sum { |s| s[1] }
			a.save!
		end
	end
end
