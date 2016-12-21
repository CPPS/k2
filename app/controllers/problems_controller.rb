class ProblemsController < ApplicationController
	def index
#		ProblemUpdateJob.perform_now
		@servers = Server.all
	end
end
