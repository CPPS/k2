# This migration adds a LDAP user flag to all users. This flag is used to
# determine whether it is allowed to login over LDAP or not. As we didn't have
# LDAP support before this migration, we default this to false.
class AddLdapUserToUsers < ActiveRecord::Migration[5.1]
	def change
		add_column :users, :ldap_user, :boolean, default: false
	end
end
