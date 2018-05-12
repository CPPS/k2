class RankChangeUpdateJob < ApplicationJob 
  def perform()
	accounts = Account.all.where.not(score: nil).order(solvedProblems: :desc, score: :asc)

	accounts.each_with_index do |account, index|
		if index != (account.prev_rank-1)
			if account.score != 0
				account.rank_changed_at = Time.now()
			end
			account.rank_delta = index-(account.prev_rank-1)
			account.prev_rank = index+1
			account.save!
		end
	end
  end
end