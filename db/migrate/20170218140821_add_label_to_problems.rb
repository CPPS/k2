# Needed for DomJudge API v2 migration
# DomJudge v5 changed the API such that the scoreboard now only contains labels
# as problem identifiers. Hence we need to save labels in the database.
class AddLabelToProblems < ActiveRecord::Migration[5.0]
	def change
		add_column :problems, :label, :string
	end
end
