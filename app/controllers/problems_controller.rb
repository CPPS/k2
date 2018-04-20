class ProblemsController < ApplicationController
	def index
		@servers = Server.all
	end

	def show
		@server = Server.find_by_id!(params[:server_id])
		@problem = Problem.find_by!(server: @server, short_name: params[:short_name])

		@accepted = @problem.submissions.accepted.includes(:account).order(created_at: :asc)
		@sub_count = @problem.submissions.group(:account_id).count

		if logged_in?
			@attempted = @problem.submissions.where(account: user_account(@server.id)).exists?
			@solved = @attempted && @problem.submissions.accepted.where(account: user_account(@server.id)).exists?
			
			@user_attempts = current_user.accounts.first.submissions.where(problem_id: @problem.id)
				.order(created_at: :desc)
				.limit(10)
		end

	end
end
