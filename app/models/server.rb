class Server < ApplicationRecord
	has_many :problems
	has_many :accounts
	has_many :submissions, through: :problems
end
