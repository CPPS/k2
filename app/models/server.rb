# Contains a server endpoint K2 will poll against.
class Server < ApplicationRecord
	has_many :problems, dependent: :destroy
	has_many :accounts, dependent: :destroy
	has_many :submissions, through: :problems

	def api_scoreboard
		scoreboard = nil
		RedisPool.with { |redis| scoreboard = redis.get("scoreboard-#{contest_id}") }
		return JSON.parse(scoreboard) if scoreboard
		puts 'Scoreboard cache fail'
		open(api_endpoint + "scoreboard?cid=#{contest_id}") do |file|
			scoreboard = file.read
		end
		RedisPool.with { |redis| redis.setex "scoreboard-#{contest_id}", 60, scoreboard }
		JSON.parse(scoreboard)
	end
end
