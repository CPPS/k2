class AddUserIdToAchievement < ActiveRecord::Migration[5.1]
  def change
  	add_column :achievements, :user_id, :integer
    add_index  :achievements, :user_id
  end
end
