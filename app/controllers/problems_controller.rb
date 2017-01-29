class ProblemsController < ApplicationController
	def index
		@servers = Server.all
	end

	def show
		@problem = Problem.find_by_server_id_and_short_name(params[:server_id], params[:short_name])
		@server = Server.find_by_id(params[:server_id])
		@accepted = @problem.submissions.accepted.includes(:account).order(created_at: :asc)
		@sub_count = @problem.submissions.group(:account_id).count
		if logged_in?
			@attempted = @problem.submissions.where(account: user_account(@server.id)).exists?
			@solved = @attempted && @problem.submissions.accepted.where(account: user_account(@server.id)).exists?
		end

	end
end
