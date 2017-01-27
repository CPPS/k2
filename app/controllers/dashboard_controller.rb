# Dashboard that shows interesting statistics to the user.
class DashboardController < ApplicationController
	def index
		@recent_attempts = Submission
		                   .includes(:account, :problem)
		                   .order(created_at: :desc)
		                   .limit(10)
		@recent_solved = Submission
		                 .accepted
		                 .includes(:account, :problem)
		                 .order(created_at: :desc).limit(10)
	end
end
