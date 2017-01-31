class ScoreUpdateJob < ApplicationJob
	queue_as :default

	# Update the scores of all users 
	def perform(account_id)
		account = Account.find(account_id)
		account.solvedProblems = Submission.accepted
		                                   .select(:problem_id).distinct
		                                   .where(account: account).count

		# Ensure the score is calculated correctly in cases where a user submits two
		# problems in one minute
		account.score = Submission.accepted
		                          .select(:problem_id, :score).distinct
		                          .where(account: account).pluck(:problem_id, :score)
		                          .sum { |score| score[1] }
		account.save!
	end
end
