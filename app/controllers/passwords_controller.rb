class PasswordsController < Devise::PasswordsController

	def new
		render nothing: true
	end

	def create
		render nothing: true
	end

	def edit
		render nothing: true
	end

	def update
    Rails.logger.debug "TRUCHOV update 1"
		# self.resource = resource_class.reset_password_by_token(resource_params)
  #   Rails.logger.debug "TRUCHOV update 2"
  #   yield resource if block_given?

  #   Rails.logger.debug "TRUCHOV update user: #{resource.errors}"
  #   if resource.errors.empty?
  #     resource.unlock_access! if unlockable?(resource)
  #     flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
  #     set_flash_message(:notice, flash_message) if is_flashing_format?
  #     sign_in(resource_name, resource)
  #     respond_with resource, :location => after_resetting_password_path_for(resource)
  #   else
  #     respond_with resource
  #   end
    user = User.find_by(reset_password_token: params[:reset_password_token])
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    Rails.logger.debug "TRUCHOV update 1 #{user.save}"
	end

end
