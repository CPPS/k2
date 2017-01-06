class Api::V1::SubmissionsController < Api::ApiController
	def index
		if params[:from]
			@submissions = Submission.where("id > ? ", params[:from].to_i)
		else
			@submissions = Submission.all
		end
		@submissions = @submissions.order(:id)
		if @submissions.empty?
			render plain:"", status: :no_content
		end
	end

	def show
		@submission = Submission.find_by_id!(params[:id])
	end
end
