class Account < ApplicationRecord
	has_many :submissions
	#has_many :servers, through: :users
	belongs_to :server
	belongs_to :user, optional: true

	def solved_problem_ids
		@solved_problem_ids ||= RedisPool.with { |r| r.smembers "account-#{id}" }
	end
end
