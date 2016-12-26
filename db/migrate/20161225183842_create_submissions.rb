class CreateSubmissions < ActiveRecord::Migration[5.0]
	def change
		create_table :submissions do |t|
			t.belongs_to :problem, index: true
			t.belongs_to :account, index: true
			t.integer :submission_id
			t.boolean :accepted
			t.string :status
			t.timestamps
		end

		add_index :submissions, [:problem_id, :submission_id], unique: true
	end
end
