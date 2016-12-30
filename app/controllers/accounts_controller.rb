class AccountsController < ApplicationController
	def list
		@accounts = Account.all
	end

	def show
		@account = Account.find(params[:id])
		@submissions = Submission.includes(:problem).where(account: @account, accepted: true).order(created_at: :desc)
		@problems = Problem.joins(:submissions).includes(:submissions).where(submissions: {account: @account, accepted: true}).order(short_name: :asc)

	end

	def create
	end

	def delete
	end
end
