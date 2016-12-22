class ProblemsController < ApplicationController
	def index
		@servers = Server.all
	end
end
