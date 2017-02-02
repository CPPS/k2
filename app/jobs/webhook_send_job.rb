# WebhookSendJob sends an outgoing HTTP job. If this hook cannot be completed
# succesfully, it will requeue itself. This is expected behaviour.
class WebhookSendJob < ApplicationJob
	queue_as :default

	def perform(hook_id, data)
		webhook = Webhook.find(hook_id)
		webhook.perform(data)
	end
end
