# Inspired by
# https://github.com/plataformatec/devise/wiki/How-To:-Authenticate-via-LDAP
require 'net/ldap'
require 'devise/strategies/authenticatable'

module Devise
	module Strategies
		# Class for logging in over LDAP and registering users if they
		# have never used K2 before.
		class LdapAuthenticatable < Authenticatable
			def authenticate!
				ldap = Net::LDAP.new(
					# Enable LDAP signature verification
					encryption: {
  						method:      :simple_tls,
						tls_options: { 
							ca_file:     '/opt/k2/shared/config/tuesmartca.pem',
               						ssl_version: 'TLSv1_1' 
						}
    					}
				)
				ldap.host = cfg[:host]
				ldap.port = cfg[:port] || 389
				ldap.auth "#{cfg[:domain]}\\#{login}", password
				ldap.encryption :simple_tls  if cfg[:encryption]
				return pass unless ldap.bind
				user = User.find_or_create_by(username: login)
				if user.new_record?
					entry = get_user_data(ldap, login)
					# The elements are arrays, so we
					# take the first element
					user.name = entry.name.first
					user.email = entry.mail.first
					# We set a random long password because
					# it is required by database
					# validations. It should not be used for
					# authentication.
					user.password = Devise.friendly_token
					user.ldap_user = true
					user.save!
				end
				success!(user)
			end

			def get_user_data(ldap, login)
				filter = Net::LDAP::Filter.eq(
					'samaccountname', login
				)
				ldap.search(base: cfg[:treebase],
				            filter: filter).first
			end

			def login
				params[:user][:login]
			end

			def password
				params[:user][:password]
			end

			# We can only login over LDAP if a login is provided,
			# LDAP data is provided in the configuration and there
			# does not exist a user in the database with the same
			# username which is not an LDAP user. This ensures that
			# we don't try to auth an empty form or a form for a
			# not-ldap user. Note that unknown users will be
			# registered when their LDAP creds are valid.
			def valid?
				params[:user] && params[:user][:login] && cfg &&
					!User.where(
						username: params[:user][:login],
						ldap_user: false
					).exists? && super
			end

			def cfg
				Rails.application.secrets.ldap
			end
		end
	end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)
