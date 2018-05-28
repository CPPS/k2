class AddMinimumSolvedAmountToAchievementData < ActiveRecord::Migration[5.1]
  def change
  	add_column :achievement_data, :minimum_solved_amount , :integer, :default => 0
  end
end
