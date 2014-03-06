module ApplicationHelper

	def isAdmin
		return current_user.id < 3
	end
end
