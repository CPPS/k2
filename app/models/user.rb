class User < ApplicationRecord
	before_save { self.email = email.downcase! }
	
	validates :name, 
		presence: true

	validates :username, 
		presence: true, 
		length: { minimum: 4 }, 
		uniqueness: { case_sensitive: false}

	validates :email, 
		presence: true, 
		uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password, 
		presence: true, 
		length: { minimum: 6 }
end
