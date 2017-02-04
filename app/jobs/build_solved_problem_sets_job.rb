# Rebuild the Redis solved problem sets.
class BuildSolvedProblemSetsJob < ApplicationJob
	queue_as :default

	def perform(*args)
		# Do something later
		Account.all.each do |a|
			solved_problems = Submission.accepted.where(account: a).pluck(:problem_id)
			RedisPool.with do |r|
				r.del "account-#{a.id}"
				solved_problems.each { |p| r.sadd "account-#{a.id}", p }
			end
		end
	end
end
