class PasswordsController < Devise::PasswordsController

	def new
		render nothing: true
	end

	def create
		render nothing: true
	end

	def edit
		super
	end

	def update
		super
	end

end
