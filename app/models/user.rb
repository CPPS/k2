# Models a user of our application
# A user can log in and is linked to accounts on servers
class User < ApplicationRecord
	has_many :accounts
	has_many :servers, through: :account

	before_save { email.downcase! }

	validates :name,
	          presence: true

	validates :username,
	          presence: true,
	          length: { minimum: 4 },
	          uniqueness: { case_sensitive: false }

	validates :email,
	          presence: true,
	          length: { minimum: 5 }, # TODO: proper regex
	          uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password,
	          presence: true,
	          allow_nil: true,
	          length: { minimum: 6 }
end
