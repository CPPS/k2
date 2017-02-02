# This migration create the webhook table. This is initially intended to allow
# chatbots to subscribe to K2 submissions in a persistent manner: If the bot is
# offline for a short time, the webhook will trigger later on the next retry.
class CreateWebhooks < ActiveRecord::Migration[5.0]
	def change
		create_table :webhooks do |t|
			t.string :name
			t.string :url
			t.string :hook_type
			t.timestamps
		end
	end
end
