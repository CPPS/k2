class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			flash[:success] = "You have been registered succesfully!"
			log_in @user
			redirect_to @user
		else
			render 'new'
		end
	end

	def index
#		@users = User.all
		if logged_in?
			redirect_to current_user
		else
			redirect_to login_path
		end
	end

	def show
		@user = User.find(params[:id])
	end

	private

		def user_params
			params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
		end
end
