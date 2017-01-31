# Contains a server endpoint K2 will poll against.
class Server < ApplicationRecord
	has_many :problems
	has_many :accounts
	has_many :submissions, through: :problems

	def api_scoreboard
		scoreboard = nil
		RedisPool.with { |redis| scoreboard = redis.get('scoreboard') }
		return JSON.parse(scoreboard) if scoreboard
		puts 'Scoreboard cache fail'
		open(api_endpoint + 'scoreboard') do |file|
			scoreboard = file.read
		end
		RedisPool.with { |redis| redis.setex 'scoreboard', 60, scoreboard }
		JSON.parse(scoreboard)
	end
end
