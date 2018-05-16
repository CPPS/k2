class AddTierToAchievementData < ActiveRecord::Migration[5.1]
  def change
  	add_column :achievement_data, :tier, :integer, :default => 2
  	remove_column :achievement_data, :img_small
  	remove_column :achievement_data, :img_large
  end
end
