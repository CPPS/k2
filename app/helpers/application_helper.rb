# This module contains various helpers related to the page title, the menu and
# the MOTD.
module ApplicationHelper
	def title(page_title)
		content_for(:title) do
			page_title
		end
		content_for(:header) do
			page_title
		end
	end

	def sub_header(sub_text)
		content_for(:sub_header) do
			sub_text
		end
	end

	def menu_link_to(text, path, controllername)
		if controller.controller_name == controllername
			content_tag(:li, link_to(text, path) +
				content_tag(:span, '(current)', class: 'sr-only'), class: 'active')
		else
			content_tag(:li, link_to(text, path))
		end
	end

	def motd
		fetch_motd unless @motd_type
		@motd
	end

	def motd_type
		fetch_motd unless @motd_type
		@motd_type
	end

	private

	def fetch_motd
		motd = nil
		motd_type = nil
		RedisPool.with do |redis|
			redis.pipelined do
				motd = redis.get 'k2motd'
				motd_type = redis.get 'k2motd-type'
			end
		end
		@motd = motd.value
		@motd_type = motd_type.value || 'info'
	end
end
