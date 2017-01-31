# This migration adds an integer "started at" to the server table. This value
# keeps track of when the contest started, such that the scores can be used to
# calculate with up to a minute accuracy when the correct submission was
# submitted.
class AddStartedAtToServer < ActiveRecord::Migration[5.0]
	def change
		add_column :servers, :started_at, :integer
	end
end
