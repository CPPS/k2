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
	# Timelimit: The submission was too slow on one or more testcases
	# Run error: This submission errored while running a testcase
	# Compiler error: This submission errored while compiling
	# No output: This submission generated no output
	enum status: {
		pending: 0,
		correct: 1,
		wrong_answer: 2,
		overcomplete: 3,
		account_hidden: 4,
		problem_hidden: 5,
		first_correct: 6,
		timelimit: 7,
		run_error: 8,
		compiler_error: 9,
		no_output: 10
	}

	belongs_to :account
	belongs_to :problem, optional: true
	has_one :user, through: :account
	has_one :server, through: :problem

	scope :accepted, -> { where(status: %i[correct first_correct]) }
	scope :attempted, -> { where(status: %i[wrong_answer timelimit run_error compiler_error no_output]) }

	def accepted?
		correct? || first_correct?
	end

	def icon
		case status
		when 'pending' then 'fa-hourglass'
		when 'correct' then 'fa-check'
		when 'wrong_answer' then 'fa-times'
		when 'first_correct' then 'fa-trophy'
		else 'fa-question'
		end
	end

	def status_text
		case status
		when 'pending' then 'Pending Judgement'
		when 'correct' then 'Correct'
		when 'wrong_answer' then 'Wrong Answer'
		when 'overcomplete' then 'Overcomplete: Solved earlier'
		when 'account_hidden' then 'Account not visible on scoreboard'
		when 'problem_hidden' then 'Problem not visible on scoreboard'
		when 'first_correct' then 'First correct'
		when 'timelimit' then 'The submission hit a timelimit'
		else "Unknown status: #{status}"
		end
	end

	def judge(judging)
		return if judged_at && judged_at >= Time.zone.at(judging['time'])
		self.judged_at = Time.zone.at(judging['time'])
		case judging['outcome']
		when 'correct' then correct!
		when 'timelimit' then timelimit!
		when 'run-error' then run_error!
		when 'wrong-answer' then wrong_answer!
		when 'compiler-error' then compiler_error!
		else raise "Unknown outcome: #{judging['outcome']}"
		end
	end
end
