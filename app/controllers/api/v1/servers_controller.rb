class Api::V1::ServersController < Api::ApiController
	def index
		@servers = Server.all
	end

	def show
		@server = Server.find_by_id!(params[:id])
	end

	def problems
		@server = Server.find_by_id!(params[:id])
	end

	def accounts
		@server = Server.find_by_id!(params[:id])
	end

	def submissions
		@server = Server.find_by_id!(params[:id])
	end
end
