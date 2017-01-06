module ProblemsHelper

	def statement_url(problem, server)
		if(server.api_type != 'domjudge')
		   puts "Other server than domjudge unsupported in ProblemsHelper#statement_url"
		end
		server.url + "problem.php?id=" + problem.problem_id
	end

	def get_all_submission_counts()
		total_subs = Submission.select("problem_id, count(distinct account_id) as total").group("problem_id")
		@count_submissions = {}
		total_subs.each { |s| @count_submissions[s.problem_id] = s.total }
		return @count_submissions
	end

	def get_all_accepted_submission_counts()
		total_accepted_subs = Submission.select("problem_id, count(distinct account_id) as total").where(accepted: true).group("problem_id")
		@count_accepted_submissions = {}
		total_accepted_subs.each { |s| @count_accepted_submissions[s.problem_id] = s.total }
		return @count_accepted_submissions
	end
end
