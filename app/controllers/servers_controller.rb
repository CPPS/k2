# Responsible for showing an overview of a server
class ServersController < ApplicationController
	def index
		@servers = Server.all
		redirect_to @servers.first if @servers.length == 1
	end

	def show
		@server = Server.find(params[:id])
		@feed = @server.submissions.includes(:account, :problem).order(submission_id: :desc).references(:accounts, :problems).limit(10)
		@problems = @server.problems.order(short_name: :asc)
		@accounts = @server.accounts.order(
			'"accounts"."solvedProblems" DESC NULLS LAST', '"accounts"."score" ASC'
		)
	end

	def auth
#		@account = Account.find(user: current_user, server_id:
#					params[:id])
		response.headers['X-Auth-Account'] = current_user.username
		render plain: 'your privileges have been checked'
	end
end
