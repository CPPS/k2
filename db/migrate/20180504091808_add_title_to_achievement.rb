class AddTitleToAchievement < ActiveRecord::Migration[5.1]
  def change
  	change_table :achievements do |t|
  		t.string :title, default: "No title"
	end
  end
end
