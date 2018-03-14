module SubmissionsHelper

	def get_servers_url
		Server.all.map do |server|
			[server.name, server.url]
		end
	end

end
