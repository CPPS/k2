class Submission < ApplicationRecord
	belongs_to :account
	belongs_to :problem
	has_one :user, through: :account
	has_one :server, through: :problem
end
