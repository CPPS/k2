class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

	include SessionsHelper
	include AccountsHelper

	# Check if the user is an admin before allowing MiniProfiler access
	before_action do
		Rack::MiniProfiler.authorize_request if	current_user.try(:admin?)
	end

	# Set up extra keys for Devise
	before_action :configure_devise_permitted_parameters, if: :devise_controller?

	protected

	# This method adds allowed parameters to devise methods. This is needed
	# because we add some extra fields, like name and username, as well as
	# login to make users able to login using their username OR email.
	# Source: https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign_in-using-their-username-or-email-address
	def configure_devise_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: %i[name username email password password_confirmation])
		devise_parameter_sanitizer.permit(:sign_in, keys: %i[login password remember_me])
		devise_parameter_sanitizer.permit(:account_update, keys: %i[name username email current_password password password_confirmation])
	end
end
