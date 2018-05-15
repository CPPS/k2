class DropRowsFromAchievements < ActiveRecord::Migration[5.1]
  def change
  	remove_column :achievements, :descr
  	remove_column :achievements, :name
  	remove_column :achievements, :filename
  	remove_column :achievements, :title
  	remove_column :achievements, :kind
  	remove_column :achievements, :level
  end
end


