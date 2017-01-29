# We are moving submission status to an enum
# In the old system, status contained a string with how K2 perceived the
# migration. There were not many statuses possible, resulting in storage of a
# lot of unnecessary data. It also made changing or localizing the status string
# hard or impossible. The boolean column "accepted" also did not contain all the
# information required, which also is why this migration is lossy: when going
# up, all solutions that were previously marked as not accepted, are now marked
# as wrong and when going down, all solutions that were not correct are now
# marked as wrong. To regenerate this data, make the servers reprocess all
# submissions.
class ChangeSubmissionStatusToEnum < ActiveRecord::Migration[5.0]
	def up
		remove_column :submissions, :status
		add_column :submissions, :status, :integer, default: 0

		Submission.all.each do |submission|
			if submission.accepted
				submission.correct!
			else
				submission.wrong!
			end
		end

		remove_column :submissions, :accepted
	end

	def down
		add_column :submissions, :accepted, :boolean

		Submission.all.each do |submission|
			submission.accepted = submission.correct?
			submission.save!
		end

		remove_column :submissions, :status
		add_column :submissions, :status, :string
	end
end
