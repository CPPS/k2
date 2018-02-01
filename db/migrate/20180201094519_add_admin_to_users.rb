# This migration add an admin attribute to the user column.
# Admin users can access Sidekiq and the profiler.
class AddAdminToUsers < ActiveRecord::Migration[5.1]
	def change
		add_column :users, :admin, :boolean, default: false
	end
end
