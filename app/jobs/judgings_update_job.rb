# Update the judgings from Domjudge, looking at each new judging as they come
# in. Judgings are linked to a certain submission, but there may be multiple
# judgings
class JudgingsUpdateJob < ApplicationJob
	queue_as :default

	def perform
		Server.where(api_type: 'domjudge').each do |server|
			server.new_judgings.each do |judging|
				judge(judging)
			end
			next unless server.changed?
			BuildSolvedProblemSets.perform_later
			server.save!
		end
	end

	def judge(judging)
		s = Submission.find_or_create_by(
			submission_id: judging['submission']
		)
		s.judge(judging)
	end
end
