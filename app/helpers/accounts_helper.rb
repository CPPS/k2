module AccountsHelper
	def user_account(server)
		@account ||= []
		@account[server.id] ||= Account.find_by(user: current_user, server: server)
	end

	def get_attempted(server)
		return @user_attempted if @user_attempted
		@user_attempted = {}
		account = user_account(server)
		if account
			attempted = Submission.attempted.where(account: account).pluck(:problem_id)
			solved = Submission.accepted.where(account: account).pluck(:problem_id)
			attempted.each { |p| @user_attempted[p] = false }
			solved.each { |p| @user_attempted[p] = true }
		end
		@user_attempted
	end
end
