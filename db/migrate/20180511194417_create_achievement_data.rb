class CreateAchievementData < ActiveRecord::Migration[5.1]
  def change
    create_table :achievement_data do |t|
      t.string :title
      t.string :description
      t.string :variable
      t.string :comparison
      t.integer :value
      t.string :img_small 
      t.string :img_large

      t.timestamps
    end

    create_table :problems_entry do |t|
    	t.integer :achievement_data_id
    	t.string :value
    end

    create_table :levels_entry do |t|
    	t.integer :achievement_data_id
    	t.string :value
    end

    create_table :prereqs_entry do |t|
    	t.integer :achievement_data_id
    	t.integer :value
    end

    add_index  :problems_entry, :achievement_data_id
    add_index  :levels_entry, :achievement_data_id
    add_index  :prereqs_entry, :achievement_data_id
  end
end
