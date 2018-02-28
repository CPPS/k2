require 'devise/strategies/database_authenticatable'

module Devise
	module Strategies
		# We need to override Devise's database authenticatable strategy
		# to prevent it from activating on LDAP users.
		class DatabaseAuthenticatable < Authenticatable
			def valid?
				request.headers['PATHINFO'] == '/auth' ||
				params[:user] && params[:user][:login] &&
					User.where(
						username: params[:user][:login],
						ldap_user: false
					).exists? && super
			end
		end
	end
end
