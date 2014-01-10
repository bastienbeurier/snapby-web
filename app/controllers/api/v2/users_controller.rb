class Api::V2::UsersController < Api::V2::ApiController
  skip_before_filter :authenticate_user!, :only => [:create,:generate_new_password_email]

  def create
    Rails.logger.debug "BAB create user: #{params}"
    user = User.new(user_params)

    if user.save
      user.ensure_authentication_token!
      render json: { result: { user: user, auth_token: user.authentication_token } }, status: 201
    else
      render json: { errors: { user: user.errors } }, status: 222 # Need a success code to handle errors in IOS
    end
  end

  def update
    Rails.logger.debug "BAB update user: #{params}"


    current_user.assign_attributes(update_user_params)

    current_user.notification_radius = params[:notification_radius] ? params[:notification_radius] : -1

    if params[:push_token]
      current_user.push_token = params[:push_token]
    end
    
    if params[:lat] and params[:lng]
      current_user.lat = params[:lat]
      current_user.lng = params[:lng]
    end

    if current_user.save
      render json: { result: {user: user } }, status: 201
    else 
      render json: { :errors => ["Failed to update user info"] }, :status => 500 
    end
  end

  def generate_new_password_email
      user = User.find_by(email: params[:email])
      user.send_reset_password_instructions
      render json: { result: { messages: ["Reset password instructions have been sent to #{user.email}."] } }, status: 201
   end


private 

  def user_params
    params.permit(:email, :password, :username, :device_model, :os_version, :os_type, :app_version, :api_version)
  end

  def update_user_params
    params.permit(:device_model, :os_version, :os_type, :app_version, :api_version)
  end
end