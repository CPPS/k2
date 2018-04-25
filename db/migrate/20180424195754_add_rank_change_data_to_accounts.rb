class AddRankChangeDataToAccounts < ActiveRecord::Migration[5.1]
  def change
  	change_table :accounts do |t|
  		t.datetime :rank_changed_at, default: Time.at(0)
  		t.integer :prev_rank, default: 2000000000 # very large number (lowest rank)
  		t.integer :rank_delta, default: 0
  		accounts = Account.all.where.not(score: nil).order(
			solvedProblems: :desc, score: :asc
		)
		accounts.each_with_index do |account, index|
			account.prev_rank = index+1
			account.save!
		end
	end
  end
end
