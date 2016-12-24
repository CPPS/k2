class ProblemsController < ApplicationController
	def index
		@servers = Server.all
	end

	def show
		@problem = Problem.find_by_server_id_and_short_name(params[:server_id], params[:short_name])
		@server = Server.find_by_id(params[:server_id])
	end
end
