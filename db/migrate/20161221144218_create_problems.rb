class CreateProblems < ActiveRecord::Migration[5.0]
  def change
    create_table :problems do |t|
      t.belongs_to :server, index: true
      t.string :problem_id
      t.string :short_name
      t.string :name

      t.timestamps
    end

    add_index :problems, [:server_id, :short_name], unique: true
  end
end
