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
      t.integer :kind

      t.timestamps
    end

    create_table :problem_entries do |t|
    	t.integer :achievement_datum_id
    	t.string :value

      t.timestamps
    end

    create_table :level_entries do |t|
    	t.integer :achievement_datum_id
    	t.string :value

      t.timestamps
    end

    create_table :prereq_entries do |t|
    	t.integer :achievement_datum_id
    	t.integer :value

      t.timestamps
    end

    add_column :achievements, :achievement_datum_id, :integer  

    add_index  :achievements, :achievement_datum_id
    add_index  :problem_entries, :achievement_datum_id
    add_index  :level_entries, :achievement_datum_id
    add_index  :prereq_entries, :achievement_datum_id
  end
end
