class AddLastSubmissionIdToServers < ActiveRecord::Migration[5.0]
  def change
	  add_column :servers, :last_submission, :int
  end
end
