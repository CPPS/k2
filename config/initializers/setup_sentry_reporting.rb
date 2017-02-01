# This file configures Raven, a client to send exceptions to Sentry.
# Please configure your Sentry DSN in config/secrets.yml.
sentry_dsn = Rails.application.secrets.sentry_dsn
if sentry_dsn
	require 'raven'
	Raven.configure do |config|
		config.dsn = sentry_dsn
		config.async = lambda { |event|
			SentryReportingJob.perform_later(event.to_hash)
		}
		config.environments = %w(production)
	end
end
