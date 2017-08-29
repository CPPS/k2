# Responsible for logging in/out users of this application
class SessionsController < ApplicationController
	def new
		flash.now[:info] = 'Please note that K2 accounts are not linked to the TU/e. DO NOT use your s-number to log in here.'
	end

	def create
		user = User.find_by(email: params[:session][:user].downcase)

		unless user
			user = User.find_by(username: params[:session][:user])
		end

		if user && user.authenticate(params[:session][:password])
			log_in user
			remember if params[:session][:remember_me] == '1'
			redirect_to user
		else
			flash.now[:danger] = "Invalid email/password combination"
			render 'new'
		end
	end

	def destroy
		if logged_in?
			flash[:info] = 'Succesfully logged out'
		else
			flash[:warning] = 'Could not log out: already logged out'
		end
		log_out
		redirect_to root_url
	end
end
