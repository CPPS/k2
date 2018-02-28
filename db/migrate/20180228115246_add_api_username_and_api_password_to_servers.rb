# Add an API Username and password to the servers. This is needed for the
# background job to read judgings from the Domjudge server, as this is only
# accessible if you authenticate as a jury user.
class AddApiUsernameAndApiPasswordToServers < ActiveRecord::Migration[5.1]
	def change
		add_column :servers, :api_username, :string
		add_column :servers, :api_password, :string
	end
end
