class LeaderboardController < ApplicationController
	def show
		@accounts = Account.all.where.not(score: nil).order(
			solvedProblems: :desc, score: :asc
		)
	end
end
