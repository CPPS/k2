require 'open-uri'
require 'json'

class ProblemUpdateJob < ApplicationJob
	queue_as :default
	
	# Update all problems know to k2
	def perform(*args)
		servers = Server.all
		for s in servers
			if(s.api_type != "domjudge")
				puts "Unsupported Judge Type: " + s.api_type
				next
			end
			
			data = ""
			open(s.api_endpoint + "problems") do |f|
				data = JSON.parse(f.read)
			end
			data.each do |p|
				problem = Problem.find_or_initialize_by(
					problem_id: p["id"], 
					server_id: s.id, 

				)
				problem.short_name = p["shortname"] 
				problem.name = p["name"]
				problem.save!
			end
		end
	end
end
