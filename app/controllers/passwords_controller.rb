class PasswordsController < Devise::PasswordsController
  skip_before_filter :require_no_authentication

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
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      # resource.unlock_access! if unlockable?(resource)
      # flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      # set_flash_message(:notice, flash_message) if is_navigational_format?
      # sign_in(resource_name, resource)
      respond_with resource, :location => after_resetting_password_path_for(resource)
    else
      respond_with resource
    end
	end

end
