class Problem < ApplicationRecord
	belongs_to :server
	has_many :submissions
	has_many :accounts, through: :submissions
end
