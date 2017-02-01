# This job sends error data to Sentry. This is done in a job to not delay
# loading the exception page
class SentryReportingJob < ApplicationJob
	queue_as :default

	def perform(event)
		Raven.send_event(event)
	end
end
