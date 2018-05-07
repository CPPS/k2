class SubmissionsController < ApplicationController
  include SubmissionGraphHelper
  
  def show
  		res = create_graph(current_user)
      
		@chart = res[:chart]
		@chart_globals = res[:chart_globals]
		@user_attempts = Submission.joins(:account)
				.where( accounts: {user_id: current_user })
				.order(created_at: :desc)
				.limit(10)
  end

  def process_submit
  		SubmissionUpdateJob.set(wait: 5.seconds).perform_later
  end

end

