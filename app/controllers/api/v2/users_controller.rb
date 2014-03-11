class Api::V2::UsersController < Api::V2::ApiController
  skip_before_filter :authenticate_user!, :only => [:create, :facebook_create_or_update]

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

    if params[:push_token]
      current_user.push_token = params[:push_token]
    end
    
    if params[:lat] and params[:lng]
      current_user.lat = params[:lat]
      current_user.lng = params[:lng]
    end

    max_age = Time.now - SHOUT_DURATION
    user_likes = Like.where("created_at >= :max_age AND liker_id = :current_user_id", 
      {max_age: max_age, current_user_id: current_user.id})

    if current_user.save
      render json: { result: {user: current_user, likes: user_likes} }, status: 201
    else 
      render json: { errors: ["Failed to update user info"] }, :status => 500 
    end
  end

  def modify_user_credentials
    Rails.logger.debug "BAB update user credentials: #{params}"

    #Only username for now, potentially profile picture, email, password in the future
    if params[:username]
      current_user.username = params[:username]
    end

    if current_user.save
      render json: { result: {user: current_user } }, status: 201
    else 
      render json: { errors: { user: current_user.errors } }, status: 222 # Need a success code to handle errors in IOS
    end
  end

  def facebook_create_or_update
 
    user = User.find_by_email(params[:email])
    
    if user
      is_signup = false
      user.facebook_id = params[:facebook_id]
      user.facebook_name = params[:facebook_name]
    else
      is_signup = true
      params[:profile_picture] = "graph.facebook.com/#{params[:username]}/picture"
      params[:username] = params[:username][0, [params[:username].length, MAX_USERNAME_LENGTH].min]
      user = User.new(facebook_user_params)
    end

    if user.save(validate: false)
      user.ensure_authentication_token!
      render json: { result: { user: user, auth_token: user.authentication_token, is_signup: is_signup} }, status: 201
    else
      render json: { errors: ["Failed to create or update user with facebook"] }, status: 500 
    end
  end

  def create_relationships_from_facebook_friends
    params[:friend_ids].each { |friend_id|
      user = User.find_by(facebook_id: friend_id)
      if user
        current_user.mutual_follow!(user)
      end
    }
    render json: { result: ["Autofollow successfully complete"] }, status: 201
  end

  def followed_users
    user = User.find(params[:user_id])
    users = user.followed_users
    render json: { result: { followed_users: users} }, status: 201
  end

  def followers
    user = User.find(params[:user_id])
    users = user.followers
    render json: { result: { followers: users} }, status: 201
  end

  # info for user profile
  def user_info
    user = User.find(params[:user_id])
    followers_count = user.followers.count
    is_followed = current_user.following?(user)
    followed_count = user.followed_users.count

    render json: { result: { user: user, followers_count: followers_count, is_followed: is_followed,
                                                            followed_count: followed_count} }, status: 201
  end

private 

  def user_params
    params.permit(:email, :password, :username, :device_model, :os_version, :os_type, :app_version, :api_version)
  end

  def update_user_params
    params.permit(:device_model, :os_version, :os_type, :app_version, :api_version)
  end

  def facebook_user_params
    params.permit(:email, :facebook_id, :facebook_name, :username, :profile_picture, :device_model, :os_version, :os_type, :app_version, :api_version)
  end
end