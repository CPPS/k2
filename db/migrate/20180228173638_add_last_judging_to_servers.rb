# The last judging field represents the last retrieved judging when updating
# judgings from a DomJudge server
class AddLastJudgingToServers < ActiveRecord::Migration[5.1]
	def change
		add_column :servers, :last_judging, :integer
	end
end
