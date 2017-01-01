class AccountsController < ApplicationController
	def list
		@accounts = Account.all
	end

	def show
		@account = Account.find(params[:id])
		@submissions = Submission.includes(:problem).where(account: @account, accepted: true).order(created_at: :desc)
		@problems = Problem.joins(:submissions).includes(:submissions).where(submissions: {account: @account, accepted: true}).order(short_name: :asc)

	end

	def new
		@available = Account.where(user_id: nil).order(:name).includes(:server)
	end

	def create
		account = Account.find_by_id(params["id"])
		if account.nil?
			flash[:danger] = "Could not link to that user: it doesn't exist"
		elsif account.user
			flash[:danger] = "Could not link to that user: " + account.name + " is already linked to " + account.user.name
		elsif not logged_in?
			flash[:danger] = "You need to log in to do that"
			redirect_to login_path
			return
		elsif Account.where(user: current_user, server: account.server).exists?
			flash[:danger] = "You are already linked to an user on that server"
		else
			account.user = current_user
			account.save!
			flash[:success] = "You are now linked to " + account.name
			redirect_to current_user
			return
		end
		redirect_to action: 'new'
	end

	#def destroy
		
	#end
end
