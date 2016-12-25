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
			content_tag(:li, link_to(text, path) + content_tag(:span, "(current)", class: "sr-only"), class: "active")
		else
			content_tag(:li, link_to(text, path))
		end
	end
end
