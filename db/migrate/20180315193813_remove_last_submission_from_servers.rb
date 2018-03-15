# This value was used to keep track of the last submission from the server. This
# was changed to server.submissions.maximum(:submission_id)
class RemoveLastSubmissionFromServers < ActiveRecord::Migration[5.1]
	def change
		remove_column :servers, :last_submission, :integer
	end
end
