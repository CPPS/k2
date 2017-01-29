# Holds a submission. It is linked to an account, and a problem
# (if that problem still exists)
class Submission < ApplicationRecord
	# Status annotations:
	# Pending: Domjudge has not fully processed this submission yet
	# Correct: Domjudge shows this submission as correct on the scoreboard
	# Wrong: Domjudge shows this submission as wrong on the scoreboard
	# Overcomplete: This submission was sent in after the first correct submission
	# 	and therefore doesn't show up on the scoreboard
	# Account hidden: The account that has sent in this submission does not appear
	# 	on the scoreboard, therefore we couldn't judge the submission
	# Problem hidden: The problem this submission adresses no longer exists in the
	# 	problem database
	# First correct: This submission is the first known correct one
	enum status: { pending: 0,
	               correct: 1,
	               wrong: 2,
	               overcomplete: 3,
	               account_hidden: 4,
	               problem_hidden: 5,
	               first_correct: 6 }

	belongs_to :account
	belongs_to :problem, optional: true
	has_one :user, through: :account
	has_one :server, through: :problem

	scope :accepted, -> { where(status: [:correct, :first_correct]) }
	scope :attempted, -> { where(status: [:wrong]) }

	def accepted?
		correct? || first_correct?
	end

	def icon
		case status
		when 'pending' then 'fa-hourglass'
		when 'correct' then 'fa-check'
		when 'wrong' then 'fa-times'
		when 'first_correct' then 'fa-trophy'
		else 'fa-question'
		end
	end
end
