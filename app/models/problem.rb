class Problem < ApplicationRecord
	belongs_to :server
	has_many :submissions
end
