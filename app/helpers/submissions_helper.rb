module SubmissionsHelper

	def get_servers_url
		Server.all.map do |server|
			[server.name, server.url, {cid: server.contest_id}]
		end
	end

end
