class SubmissionsController < ApplicationController
  def show
		@user_attempts = Submission.joins(:account)
				.where( accounts: {user_id: current_user })
				.order(created_at: :desc)
				.limit(10)
  end
end
