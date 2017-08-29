# Contains various helpers related to signing in/out or retrieving the
# currently logged in user.
module SessionsHelper
	def log_in(user)
		user.create_session
		session[:user_id] = user.id
		session[:session_token] = user.session_token
	end

	def log_out
		current_user.destroy_session if logged_in?
		session.delete :user_id
		session.delete :session_token
		cookies.delete :user_id
		cookies.delete :session_token
	end

	def remember
		cookies.permanent.signed[:user_id] = session[:user_id]
		cookies.permanent.signed[:session_token] = session[:session_token]
	end

	def current_user
		return @current_user if @current_user_checked
		@current_user_checked = true
		return nil if user_id.nil? || session_token.nil?
		user = User.find_by(id: user_id)
		@current_user = user if user && user.authenticated?(session_token)
		@current_user
	end

	def logged_in?
		!current_user.nil?
	end

	def admin?
		logged_in? && current_user.id == 1
	end

	def session_invalid?
		current_user.nil? && !user_id.nil?
	end

	private

	def user_id
		@user_id ||= session[:user_id] || cookies.signed[:user_id]
	end

	def session_token
		@session_token ||= session[:session_token] || cookies.signed[:session_token]
	end
end
