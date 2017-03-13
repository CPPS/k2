# This job checks the status of a single submission. This job must be
# idempotent and return the same results regardless of when it was initially
# performed.
class SubmissionStatusUpdateJob < ApplicationJob
	queue_as :default

	def perform(submission_id, retries_left = 3)
		submission = Submission.find(submission_id)
		problem = submission.problem
		unless problem
			submission.problem_hidden!
			return
		end
		account_id = submission.account.account_id
		account_scoreboard = submission.server.api_scoreboard.select do |account|
			account['team'] == account_id
		end

		if account_scoreboard.empty?
			submission.account_hidden!
			return
		end

		entry = account_scoreboard.first['problems'].select { |e| e['label'] == problem.label }.first
		if entry['num_judged'].to_i.zero?
			requeue(submission_id, retries_left)
			return
		end

		score_time = submission.server.started_at + entry['time'].to_i * 60
		if entry['solved']
			if close_to(submission.created_at.getutc.to_i, score_time)
				submission.score = entry['time'].to_i + entry['penalty'].to_i
				# Prevent duplicate messages when regrading
				send_notification(submission, entry) unless submission.correct?
				submission.correct!
				RedisPool.with do |redis|
					redis.sadd "account-#{submission.account.id}", problem.id
				end
				ScoreUpdateJob.perform_later(submission.account.id)
			elsif submission.created_at.to_i < score_time
				submission.wrong!
			else
				submission.overcomplete!
			end
		else
			submission.wrong!
			# We requeue because it is possible that this is a second submission which
			# is currently being graded. This only needs to be done once more.
			retries_left = 1 if retries_left > 1
			requeue(submission_id, retries_left)
		end
	end

	private

	# Because values on the scoreboard are rounded to the minute, we need to add
	# some logic to check if the timestamps are close enough. This catches a lot of
	# the edge cases, but not all of them. Currently, out of ~4000 submissions, 13
	# pairs of submissions have been submitted in the same minute, with at least
	# one of them correct. We cannot determine which one is correct, so the code
	# will accept them both.
	def close_to(a, b)
		a / 60 == b / 60
	end

	def requeue(submission_id, retries_left)
		return if retries_left.zero?
		SubmissionStatusUpdateJob
			.set(wait: 5.minutes)
			.perform_later(submission_id, retries_left - 1)
	end

	# Prepares the webhook notification
	def send_notification(submission, entry)
		data = { 'account_name' => submission.account.name,
		         'problem_name' => submission.problem.display_name,
		         'submissions_count' => entry['num_judged'],
		         'language' => submission.language }
		Webhook.trigger('submission', data)
	end
end
