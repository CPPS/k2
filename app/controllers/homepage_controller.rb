class HomepageController < ApplicationController
  def show
	if signed_in?
		redirect_to controller: "/dashboard", action: "index"
	else
		redirect_to controller: "/leaderboard", action: "show"
	end
  end
end
