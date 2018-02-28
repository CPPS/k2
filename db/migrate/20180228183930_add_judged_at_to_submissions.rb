# This class adds a timestamp to the submissions table to keep track of the time
# the last judging was performed. This timestamp is used to determine if a new
# judging should update the submission or not.
class AddJudgedAtToSubmissions < ActiveRecord::Migration[5.1]
	def change
		add_column :submissions, :judged_at, :datetime
	end
end
