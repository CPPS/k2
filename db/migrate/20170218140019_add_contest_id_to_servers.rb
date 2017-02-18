# Needed for DomJudge API v2 migration
# In Domjudge 5, support for multiple contests was added. To distinguish between
# API calls for each contest, you need to add the cid parameter to each request.
# If you want K2 to track multiple constests, add multiple servers with a
# different contest id to the database.
class AddContestIdToServers < ActiveRecord::Migration[5.0]
	def change
		add_column :servers, :contest_id, :integer
	end
end
