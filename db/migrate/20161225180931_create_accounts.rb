class CreateAccounts < ActiveRecord::Migration[5.0]
	def change
		create_table :accounts do |t|
			t.string :name
			t.belongs_to :user, index: true
			t.belongs_to :server, index: true
			t.integer :account_id
			t.integer :solvedProblems
			t.integer :score
			t.timestamps
		end

		add_index :accounts, [:user_id, :server_id], unique: true
		add_index :accounts, [:account_id, :server_id], unique: true
	end
end
