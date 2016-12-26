require 'open-uri'
require 'json'

class AccountUpdateJob < ApplicationJob
	queue_as :default

	# Update all accounts on the server
	def perform(*args)
		servers = Server.all
		for s in servers
			if(s.api_type != "domjudge")
				puts "Unsupported Judge type: " + s.api_type
				next
			end

			data = ""
			open(s.api_endpoint + "teams") do |f|
				data = JSON.parse(f.read)
			end
			data.each do |a|
				account = Account.find_or_initialize_by(
					account_id: a["id"],
					server_id: s.id,
					name: a["name"]
				)
				account.save!
			end
		end

	end
end
