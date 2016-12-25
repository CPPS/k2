class CreateAccounts < ActiveRecord::Migration[5.0]
	def change
		create_table :accounts do |t|
			t.string :name
			t.belongs_to :user, index: true
			t.belongs_to :server, index: true
			t.integer :solvedProblems
			t.integer :score
			t.timestamps
		end
	end
end
