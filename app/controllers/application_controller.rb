class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

	include SessionsHelper
	include AccountsHelper

	# Check if the user is an admin before allowing MiniProfiler access
	before_action do
		if is_admin?
			Rack::MiniProfiler.authorize_request
		elsif session_invalid?
			flash.now[:danger] = 'You have been logged out automatically due to logging in on a different system'
			log_out
		end
	end
end
