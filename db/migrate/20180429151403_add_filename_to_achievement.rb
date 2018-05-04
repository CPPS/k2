class AddFilenameToAchievement < ActiveRecord::Migration[5.1]
  def change
  	change_table :achievements do |t|
  		t.string :filename, default: "/trophies/gold.png"
	end
  end
end
