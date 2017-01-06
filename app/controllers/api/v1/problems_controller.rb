class Api::V1::ProblemsController < Api::ApiController
	def index
		@problems = Problem.all
	end

	def show
		@problem = Problem.find_by_id!(params[:id])
	end
end
