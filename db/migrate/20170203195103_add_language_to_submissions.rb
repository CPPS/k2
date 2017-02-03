# This migration adds a column "language" to submissions, which indicates in
# which programming language the submission was made.
class AddLanguageToSubmissions < ActiveRecord::Migration[5.0]
	def change
		add_column :submissions, :language, :string
	end
end
