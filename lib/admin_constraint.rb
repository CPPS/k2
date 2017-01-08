class AdminConstraint
	def matches?(request)
		request.session[:user_id] == 1
	end
end
