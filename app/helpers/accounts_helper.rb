module AccountsHelper
	def has_account?(server)
		!get_account(server).nil?
	end

	def get_account(server)
		@account ||= []
		@account[server.id] ||= Account.find_by(user: current_user, server: server)
	end

	def get_attempted(problems, server)
		return @user_attempted unless @user_attempted.nil?
		@user_attempted = {}
		if has_account? server
			attempted = problems.includes(:submissions).where(submissions: { account: get_account(server), accepted: false}).references(:submissions)
			solved = problems.includes(:submissions).where(submissions: { account: get_account(server), accepted: true}).references(:submissions)
			attempted.each { |p| @user_attempted[p.id] = false }
			solved.each { |p| @user_attempted[p.id] = true }
		end
		return @user_attempted
	end
end
