class AddLevelToAchievements < ActiveRecord::Migration[5.1]
  def change
  	add_column :achievements, :level, :integer
  	add_column :level_entries, :position, :integer
  end
end
