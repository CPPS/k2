# Model for the users of our application
# A user can log in and can be linked to server accounts.
class User < ApplicationRecord
	# We link multiple accounts to each user, with each account
	# representing an external registration.
	has_many :accounts
	has_many :servers, through: :account

	# The login attribute is used to allow signin with either username or
	# password.
	attr_accessor :login

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	       :recoverable, :rememberable, :trackable, :validatable

	# Validation rules:
	# Username, name, email, password must be present
	# Username, email must be unique when lowercased (BANANA == banana)
	# Emails must and Usernames must not contain the @-sign
	validates :username,
	          presence: true,
	          uniqueness: { case_sensitive: false },
	          format: { without: /@/, message: "can't use @" }

	validates :name,
	          presence: true

	# This method allows ActiveRecord to retrieve a user from the database
	# using either the username or the email.
	def self.find_for_database_authentication(warden_conditions)
		conditions = warden_conditions
		if (login = conditions.delete(:login))
			where(conditions.to_hash).find_by(
				['username = :value OR email = :value',
				 { value: login.downcase }]
			)
		else
			find_by(conditions.to_hash)
		end
	end
end
