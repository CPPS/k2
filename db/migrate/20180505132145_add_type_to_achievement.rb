class AddTypeToAchievement < ActiveRecord::Migration[5.1]
  def change
  	change_table :achievements do |t|
  		t.column :type, :integer, default: 0
	end
  end
end
