# Holds a submission. It is linked to an account, and a problem
# (if that problem still exists)
class Submission < ApplicationRecord
	belongs_to :account
	belongs_to :problem, optional: true
	has_one :user, through: :account
	has_one :server, through: :problem

	scope :accepted, -> { where(accepted: true) }
	scope :attempted, -> { where(accepted: false) }
end
