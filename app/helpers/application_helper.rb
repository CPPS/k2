module ApplicationHelper

	def menu_link_to(text, path, controllername)
		if controller.controller_name == controllername
			content_tag(:li, link_to(text, path) + content_tag(:span, "(current)", class: "sr-only"), class: "active")
		else
			content_tag(:li, link_to(text, path))
		end
	end
end
