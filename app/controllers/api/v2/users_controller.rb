class Api::V2::UsersController < Api::V2::ApiController
  skip_before_filter :authenticate_user!, :only => [:create, :facebook_create_or_update]

  def create
    Rails.logger.debug "BAB create user: #{params}"

    user = User.new(user_params)

    user.save_and_return_token
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
      render json: { result: {user: current_user } }, status: 201
    else 
      render json: { :errors => ["Failed to update user info"] }, :status => 500 
    end
  end

  def facebook_create_or_update
      user = User.find_by_email(params[:email])
      if user
        user.facebook_id = params[:facebook_id]
        user.facebook_name = params[:facebook_name]
      else
        user = User.new(facebook_user_params)
      end
      user.save_and_return_token
  end

private 

  def save_and_return_token
    if user.save
      user.ensure_authentication_token!
      render json: { result: { user: user, auth_token: user.authentication_token } }, status: 201
    else
      render json: { errors: { user: user.errors } }, status: 222 # Need a success code to handle errors in IOS
    end
  end

  def user_params
    params.permit(:email, :password, :username, :device_model, :os_version, :os_type, :app_version, :api_version)
  end

  def update_user_params
    params.permit(:device_model, :os_version, :os_type, :app_version, :api_version)
  end

  def facebook_user_params
    params.permit(:email, :facebook_id, :facebook_name, :username)
    params[:username] = params[:username].str[0,MAX_USERNAME_LENGTH]
  end
end