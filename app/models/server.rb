require 'open-uri'

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

	# Get the last n judgings from this server. Updates the last_judging
	# count.
	def new_judgings(n = 100)
		result = api_get('judgings', cid: contest_id, limit: n,
		                             fromid: last_judging)
		self.last_judging = result.last['id']
		result
	end

	# Make an api HTTP GET call to this server. For example, to get the
	# scoreboard, call api_get('scoreboard', cid: 2) to retrieve the
	# scoreboard for contest 2. Please see the Domjudge manual for the
	# available API calls.
	def api_get(function, params = {})
		uri = URI.parse(api_endpoint + function + '?' + params.to_query)
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Get.new(uri.request_uri)
		request.basic_auth(api_username, api_password)
		response = http.request(request)
		JSON.parse response.body
	end
end
