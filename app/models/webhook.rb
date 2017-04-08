require 'net/http'
require 'json'

class Webhook < ApplicationRecord
	def self.targets(hook_type)
		Webhook.where(hook_type: hook_type)
	end

	def perform(data)
		uri = URI(url)
		request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
		request.body = data.encode('utf-8')
		response = Net::HTTP.start(uri.hostname, uri.port) do |http|
			http.request(request)
		end
		raise response.code if response.code != '200'
	end

	def self.trigger(hook_type, data)
		targets(hook_type).ids.each do |hook_id|
			WebhookSendJob.perform_later(hook_id, data.to_json)
		end
	end
end
