# This module contains helpers related to retrieving the user accounts and
# attempted problems from user accounts.
module AccountsHelper
	def user_account(server_id)
		@account ||= []
		@account[server_id] ||= Account
		                        .find_by(user: current_user, server_id: server_id)
	end

	def get_attempted(server)
		user_attempted = {}
		account = user_account(server)
		if account
			attempted = Submission.attempted.where(account: account).pluck(:problem_id)
			solved = Submission.accepted.where(account: account).pluck(:problem_id)
			attempted.each { |p| user_attempted[p] = false }
			solved.each { |p| user_attempted[p] = true }
		end
		user_attempted
	end
end
