require 'clockwork'
require 'active_job'

ActiveJob::Base.queue_adapter = :sidekiq

#Load all AJ job
require File.join(File.expand_path('.'), 'app', 'jobs', 'application_job')
Dir.glob(File.join(File.expand_path('.'), 'app', 'jobs', '**')).each { |f| require f }

# DSL Docs: https://github.com/Rykian/clockwork
module Clockwork
	handler do |job|
		puts "Running #{job}"
	end

	every(1.day, 'problems.update') { ProblemUpdateJob.perform_later }
	every(1.day, 'accounts.update') { AccountUpdateJob.perform_later }
end
