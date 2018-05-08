class AddLevelAndIsActiveToAchievements < ActiveRecord::Migration[5.1]
  def change
  	change_table :achievements do |t|
  		t.column :level, :integer, default: 0
  		t.column :isActive, :boolean, :default => true
	end
  end
end
