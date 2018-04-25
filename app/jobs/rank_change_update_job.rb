require 'json'

class AchievementUpdateJob < ApplicationJob
 
  def perform(user, judged_at) #user, judged_at)

	if (user.nil? or user.accounts.nil?)
		return
	end

	accounts = Account.all.where.not(score: nil).order(
		solvedProblems: :desc, score: :asc)

	accounts.each_with_index do |account, index|
		if(index != account.prev_rank-1) 
			account.rank_delta = index-(prev_rank-1)
			accounts.rank_changed_at = Time.now()
			account.prev_rank = index+1
			account.save!
		end
	end
  end
end