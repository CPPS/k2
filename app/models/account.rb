class Account < ApplicationRecord
	has_many :submissions
	has_many :servers, through: :users
end
