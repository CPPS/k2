class SubmissionsController < ApplicationController
  def show
		@user_attempts = Submission.joins(:account)
				.where( accounts: {user_id: current_user })
				.order(created_at: :desc)
				.limit(10)
  end

  def process_submit
  		debugger
  		SubmissionUpdateJob.set(wait: 5.seconds).perform_later
  end

end
