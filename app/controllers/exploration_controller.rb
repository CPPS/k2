class ExplorationController < ApplicationController
	def random
		if logged_in?
			accounts = Account.where(user: current_user).ids
			solved = Submission.accepted.where(account_id: accounts).pluck(:problem_id)
			problem = Problem.where.not(id: solved).sample
		else
			problem = Problem.all.sample
		end
		redirect_to kaas_path(problem.server_id, problem.short_name)
	end
end
