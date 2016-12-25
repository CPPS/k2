class CreateSubmissions < ActiveRecord::Migration[5.0]
	def change
		create_table :submissions do |t|
			t.belongs_to :problem, index: true
			t.belongs_to :account, index: true
			t.boolean :accepted
			t.string :status
			t.timestamps
		end
	end
end
