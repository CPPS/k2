class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

	include SessionsHelper
	include AccountsHelper

	# Check if the user is an admin before allowing MiniProfiler access
	before_action do
		if is_admin?
			Rack::MiniProfiler.authorize_request
		end
	end
end
