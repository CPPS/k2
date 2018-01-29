# Model for the users of our application
# A user can log in and can be linked to server accounts.
class User < ApplicationRecord
	# We link multiple accounts to each user, with each account
	# representing an external registration.
	has_many :accounts
	has_many :servers, through: :account

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	       :recoverable, :rememberable, :trackable, :validatable
end
