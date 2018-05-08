require 'open-uri'
require 'json'

class Tempjob < ApplicationJob

	# Update all accounts on the server
	def perform
		File.readlines('people').each do |line|
		  oFields = Array.new
		  oFields = line.split(' ')
		  fields = Array.new
		  fields[0] = oFields.first
		  fields[1] = oFields[1..-2].join(' ')
		  fields[2] = oFields.last
		  newUser = User.new
		  newUser.username = fields[0]
		  newUser.name = fields[1]
		  newUser.email = fields[2]
		  newUser.ldap_user = true
		  newUser.password = Devise.friendly_token	
		  newUser.accounts = []
		  newUser.save!
		end
	end

	def perform2
		Account.all.each do |a| 
			
			if (User.where(:name => a.name).exists?) 
				a.user = User.find_by(name: a.name) 
				a.save!
			else 
				u = User.new
				u.name = a.name
				u.password = Devise.friendly_token
				u.username = a.name
				u.email = Devise.friendly_token + "123@example.org"
				debugger
				u.save!
				a.user = u;
				a.save!
			end
		end
	end
end
