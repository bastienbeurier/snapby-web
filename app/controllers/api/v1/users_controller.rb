class Api::V1::UsersController < Api::V1::ApiController
  include ApplicationHelper
  skip_before_filter :authenticate_user!, :only => [:create, :facebook_create_or_update]

  def create
    Rails.logger.debug "BAB create user: #{params}"

    user = User.new(user_params)

    if user.save
      WelcomeEmailWorker.perform_async(user.id)

      user.ensure_authentication_token!
      render json: { result: { user: user.response_user, auth_token: user.authentication_token } }, status: 201
    else
      render json: { errors: { user: user.errors } }, status: 222 # Need a success code to handle errors in IOS
    end
  end

  def update
    Rails.logger.debug "BAB update user: #{params}"

    new_username = false

    if (params[:username] and params[:username] != current_user.username)
      new_username = true
    end

    current_user.assign_attributes(user_params)

    if params[:avatar]
      current_user.avatar = StringIO.new(Base64.decode64(params[:avatar]))
    end

    if current_user.save
      if new_username
        UpdateUsernameWorker.perform_async(current_user.id)
      end

      render json: { result: {user: current_user.response_user} }, status: 201
    else 
      render json: { errors: { user: current_user.errors } }, status: 222 # Need a success code to handle errors in IOS
    end
  end

  def my_likes
    user_likes = Like.where("liker_id = :current_user_id", {current_user_id: current_user.id})
    render json: { result: { likes: user_likes.collect(&:snapby_id) } }, status: 201  
  end


  def facebook_create_or_update
 
    user = User.find_by_email(params[:email]) 
    
    if user
      is_signup = false
      user.facebook_id = params[:facebook_id]
      user.facebook_name = params[:facebook_name]
    else
      is_signup = true
      params[:username] = params[:username][0, [params[:username].length, MAX_USERNAME_LENGTH].min]
      user = User.new(facebook_user_params)
    end

    if user.save(validate: false)
      if is_signup
        FacebookProfilePictureWorker.perform_async(user.id)
      end

      user.ensure_authentication_token!
      render json: { result: { user: user.response_user, auth_token: user.authentication_token, is_signup: is_signup} }, status: 201
    else
      render json: { errors: ["Failed to create or update user with facebook"] }, status: 500 
    end
  end

  def get_user_info
    user = User.find(params[:user_id])

    render json: { result: { user: user.response_user} }, status: 201
  end

private 

  def user_params
    params.permit(:email, :password, :username, :device_model, :os_version, :os_type, :app_version, :api_version, :push_token, :lat, :lng)
  end

  def facebook_user_params
    params.permit(:email, :facebook_id, :facebook_name, :username, :device_model, :os_version, :os_type, :app_version, :api_version)
  end
end