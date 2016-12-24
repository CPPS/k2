module ProblemsHelper

	def statement_url(problem, server)
		if(server.api_type != 'domjudge')
		   puts "Other server than domjudge unsupported in ProblemsHelper#statement_url"
		end
		server.url + "problem.php?id=" + problem.problem_id
	end
end
