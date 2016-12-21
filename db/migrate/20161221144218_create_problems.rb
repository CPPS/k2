class CreateProblems < ActiveRecord::Migration[5.0]
  def change
    create_table :problems do |t|
      t.belongs_to :server, index: true
      t.string :problem_id
      t.string :name

      t.timestamps
    end
  end
end
