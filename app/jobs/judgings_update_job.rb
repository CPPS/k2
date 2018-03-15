# Update the judgings from Domjudge, looking at each new judging as they come
# in. Judgings are linked to a certain submission, but there may be multiple
# judgings
class JudgingsUpdateJob < ApplicationJob
	queue_as :default

	def perform
		Server.where(api_type: 'domjudge').each do |server|
			server.new_judgings.each do |judging|
				judge(server, judging)
			end
			next unless server.changed?
			BuildSolvedProblemSetsJob.perform_later
			server.save!
		end
	end

	def judge(server, judging)
		s = server.submissions.find_by(
			submission_id: judging['submission']
		)
		s ||= server.create_submission_by_id(judging['submission'])
		s.judge(judging)
	end
end
