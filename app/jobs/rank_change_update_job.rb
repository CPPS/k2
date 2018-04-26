class RankChangeUpdateJob < ApplicationJob 
  def perform()
  	# this is vlad's work
	accounts = Account.all.where.not(score: nil).order(
		solvedProblems: :desc, score: :asc)

	accounts.each_with_index do |account, index|
		if index != account.prev_rank-1
			if account.score != 0
				accounts.rank_changed_at = Time.now()
			account.rank_delta = index-(prev_rank-1)
			account.prev_rank = index+1
			account.save!
		end
	end
  end
end