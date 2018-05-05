# Show user pages and handle (un)linking to users
class AccountsController < ApplicationController
	before_action :enforce_login, only: %i[new create destroy]
	include SubmissionsGraphHelper

	def index
		@accounts = Account.all
	end

	def show
		@account = Account.find(params[:id])
		@submissions = Submission.accepted
		                         .includes(:problem)
		                         .where(account: @account)
		                         .order(created_at: :desc)
		@problems = Problem.joins(:submissions)
		                   .includes(:submissions)
		                   .where(submissions: { account: @account, status: [:correct, :first_correct] })
		                   .order(short_name: :asc)

		if not @account.user.nil?
			@achievements = @account.user.achievements

			res = create_graph(@account.user)
			@chart = res[:chart]
			@chart_globals = res[:chart_globals]
		end

		# Only show the compare part if you are logged in
		#   and not looking at your own page
		return unless logged_in?
		@current_user_account = Account.find_by(server_id: @account.server_id,
		                                        user: current_user)
		@show_compare = @current_user_account && @account != @current_user_account

		return unless @show_compare
		# "My" refers to the currently logged in user, "their" refers to the
		#   user whose page is currently being accessed
		my_account = "account-#{@current_user_account.id}"
		their_account = "account-#{@account.id}"
		RedisPool.with do |r|
			r.pipelined do
				@my_exclusive_ids = r.sdiff my_account, their_account
				@their_exclusive_ids = r.sdiff their_account, my_account
			end
		end
		@my_exclusive_problems = Problem.where(id: @my_exclusive_ids.value)
		@their_exclusive_problems = Problem.where(id: @their_exclusive_ids.value)
	end

	def new
		@available = Account.where(user_id: nil).order(:server_id, :name).includes(:server)
	end

	def create
		account = Account.find(params['id'])
		if account.nil?
			flash[:danger] = "Could not link to that user: it doesn't exist"
		elsif account.user
			flash[:danger] = "Could not link to that user: #{account.name} is already linked to #{account.user.name}"
		elsif Account.where(user: current_user, server: account.server).exists?
			flash[:danger] = 'You are already linked to an user on that server'
		else
			account.user = current_user
			account.save!
			flash[:success] = "You are now linked to #{account.name}"
			redirect_to current_user
			return
		end
		redirect_to action: 'new'
	end

	def destroy
		account = Account.find(params['id'])
		if account.user.nil?
			flash[:danger] = 'Could not unlink that user: it is not linked'
		elsif account.user != current_user
			flash[:danger] = 'Could not unlink that user: it is not linked to you'
		else
			account.user = nil
			account.save!
			flash[:success] = "You are no longer linked to #{account.name}"
		end
		redirect_to current_user
	end

	private

	def enforce_login
		return if logged_in?
		flash[:danger] = 'You need to log in to do that'
		redirect_to login_url
	end
end
