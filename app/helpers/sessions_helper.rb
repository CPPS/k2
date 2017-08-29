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
	end

	def current_user
		return @current_user if @current_user_checked
		@current_user_checked = true
		return nil if session[:user_id].nil? || session[:session_token].nil?
		user = User.find_by(id: session[:user_id])
		@current_user = user if user && user.authenticated?(session[:session_token])
		@current_user
	end

	def logged_in?
		!current_user.nil?
	end

	def is_admin?
		logged_in? && current_user.id == 1
	end

	def session_invalid?
		current_user.nil? && !session[:user_id].nil?
	end
end
