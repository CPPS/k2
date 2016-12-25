class Server < ApplicationRecord
	has_many :problems
	has_many :accounts
	has_many :servers, through: :account
end
