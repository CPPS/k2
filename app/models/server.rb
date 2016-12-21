class Server < ApplicationRecord
	
	def problems
		return Problem.where(server_id: self.id)
	end

end
