# Contains various helpers for dealing with problem objects.
module ProblemsHelper
	def statement_url(problem, server)
		# This method only supports Domjudge problems
		raise NotImplementedError if server.api_type != 'domjudge'
		"#{server.url}problem.php?id=#{problem.problem_id}"
	end

	def count_submissions
		total_subs = Submission
		             .select('problem_id, count(distinct account_id) AS total')
		             .group(:problem_id)
		@count_submissions = {}
		total_subs.each { |s| @count_submissions[s.problem_id] = s.total }
		@count_submissions
	end

	def count_accepted_submissions
		accepted_subs = Submission
		                .accepted
		                .select('problem_id, count(distinct account_id) AS total')
		                .group(:problem_id)
		@count_accepted_submissions = {}
		accepted_subs.each { |s| @count_accepted_submissions[s.problem_id] = s.total }
		@count_accepted_submissions
	end

	def get_shortnames
		a = Problem.all.map do |problem| 
			[problem.short_name, problem.short_name] 
		end
		return a
	end
end
