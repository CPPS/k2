class Account < ApplicationRecord
	has_many :submissions
	#has_many :servers, through: :users
	has_one :server
	has_one :user
end
