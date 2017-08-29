# Adds a session token digest to the users table. The session digest is used
# in combination with an userid to authenticate a user when logged in.
class AddSessionTokenDigestToUsers < ActiveRecord::Migration[5.1]
	def change
		add_column :users, :session_token_digest, :string
	end
end
