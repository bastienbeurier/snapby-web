class Api::V2::UsersController < Api::V2::ApiController
  skip_before_filter :authenticate_user!, :only => [:create, :facebook_create_or_update]

  def create
    Rails.logger.debug "BAB create user: #{params}"

    user = User.new(user_params)

    if user.save
      user.ensure_authentication_token!
      render json: { result: { user: user.response_user, auth_token: user.authentication_token } }, status: 201
    else
      render json: { errors: { user: user.errors } }, status: 222 # Need a success code to handle errors in IOS
    end
  end

  #TODO: REMOVE LIKE LOGIC FROM HERE
  def update
    Rails.logger.debug "BAB update user: #{params}"

    current_user.assign_attributes(user_params)

    if params[:avatar]
      current_user.avatar = StringIO.new(Base64.decode64(params[:avatar]))
    end

    max_age = Time.now - SHOUT_DURATION
    user_likes = Like.where("created_at >= :max_age AND liker_id = :current_user_id", 
      {max_age: max_age, current_user_id: current_user.id})

    if current_user.save
      render json: { result: {user: current_user.response_user, likes: user_likes} }, status: 201
    else 
      render json: { errors: { user: current_user.errors } }, status: 222 # Need a success code to handle errors in IOS
    end
  end

  #DEPRECATED: use update
  def modify_user_credentials
    Rails.logger.debug "BAB update user credentials: #{params}"

    #Only username for now, potentially profile picture, email, password in the future
    if params[:username]
      current_user.username = params[:username]
    end

    if current_user.save
      render json: { result: {user: current_user.response_user } }, status: 201
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
      params[:username] = params[:username][0, [params[:username].length, MAX_USERNAME_LENGTH].min]
      user = User.new(facebook_user_params)

      user.avatar = open("http://graph.facebook.com/#{user.facebook_id}/picture")
    end

    if user.save(validate: false)
      user.ensure_authentication_token!
      render json: { result: { user: user.response_user, auth_token: user.authentication_token, is_signup: is_signup} }, status: 201
    else
      render json: { errors: ["Failed to create or update user with facebook"] }, status: 500 
    end
  end

  # facebook autofollow
  def create_relationships_from_facebook_friends
    User.where(facebook_id: params[:friend_ids]).each { |user|
      current_user.mutual_follow!(user)
    }
    render json: { result: ["Autofollow successfully complete"] }, status: 201
  end

  # get users we follow
  def followed_users
    user = User.find(params[:user_id])
    render json: { result: { followed_users: User.response_users(user.followed_users), 
                             current_user_followed_user_ids: current_user.followed_user_ids } }, status: 201
  end

  #get followers
  def followers
    user = User.find(params[:user_id])
    render json: { result: { followers: User.response_users(user.followers), 
                             current_user_followed_user_ids: current_user.followed_user_ids } }, status: 201
  end

  def get_user_info
    user = User.find(params[:user_id])
    followers_count = user.followers.count
    is_followed = current_user.following?(user)
    followed_count = user.followed_users.count

    render json: { result: { user: user.response_user, followers_count: followers_count, is_followed: is_followed,
                                                            followed_count: followed_count} }, status: 201
  end

  # Suggest people to follow
  def suggested_friends
    suggested_friends = User.where("lat IS NOT NULL").by_distance(origin: current_user).first(100)
                                                              .select{ |user| !current_user.following?(user) && user != current_user}
    sorted_friends = suggested_friends.sort_by(&:shout_count).reverse
    render json: { result: { suggested_friends: User.response_users(sorted_friends), 
                             current_user_followed_user_ids: current_user.followed_user_ids} }, status: 200
  end

private 

  def user_params
    params.permit(:email, :password, :username, :device_model, :os_version, :os_type, :app_version, :api_version, :push_token, :lat, :lng)
  end

  def facebook_user_params
    params.permit(:email, :facebook_id, :facebook_name, :username, :device_model, :os_version, :os_type, :app_version, :api_version)
  end
end