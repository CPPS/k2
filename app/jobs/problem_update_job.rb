require 'open-uri'
require 'json'

class ProblemUpdateJob < ApplicationJob
	queue_as :default

	def perform(*args)
		# Do something later
		servers = Server.all
		for s in servers
			if(s.api_type != "domjudge")
				puts "Unsupported Judge Type: " + s.type
				next
			end
			
			data = ""
			open(s.api_endpoint + "problems") do |f|
				data = JSON.parse(f.read)
			end
			data.each do |p|
				problem = Problem.find_or_initialize_by(problem_id: p["id"], server_id: s.id)
				problem.name = p["shortname"] + ": " + p["name"]
				problem.save
			end
		end
	end
end
