class AddNameToAchievement < ActiveRecord::Migration[5.1]
  def change
  	add_column :achievements, :name, :string
  end
end
