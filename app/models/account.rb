class Account < ApplicationRecord
	has_many :submissions
	#has_many :servers, through: :users
	belongs_to :server
	belongs_to :user, optional: true
end
