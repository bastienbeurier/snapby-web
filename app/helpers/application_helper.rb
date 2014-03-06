module ApplicationHelper

	def is_admin
		return current_user.id < 3
	end
end
