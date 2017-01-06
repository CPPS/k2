class Api::V1::AccountsController < Api::ApiController
	def index
		@accounts = Account.all
	end

	def show
		@account = Account.find_by_id!(params[:id])
	end
end
