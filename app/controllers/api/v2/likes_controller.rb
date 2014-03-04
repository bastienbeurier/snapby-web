class Api::V2::LikesController < Api::V2::ApiController

  #User creates like
  def create
    Rails.logger.debug "BAB create like params: #{params}"

    params[:liker_id] = current_user.id
    params[:liker_username] = current_user.username

    shout = Shout.find(params[:shout_id])

    if shout.likes.collect(&:liker_id).include? current_user.id
      render json: { errors: { invalid: ["Shout already liked by user"] } }, :status => 406
      return
    end

    like = Like.new(like_params)  
    
    if like.save
      shout.like_count += 1
      shout.save
      render json: { result: { like_count: shout.like_count } }, status: 201
    else 
      render json: { errors: { internal: like.errors } }, :status => 500
    end
  end

  #Display likes for a shout
  def index
    Rails.logger.debug "BAB index likes params: #{params}"

    if !params[:shout_id]
      render json: { errors: {incomplete: ["Incomplete like information"] } }, :status => 406
      return
    end

    shout = Shout.find(params[:shout_id])

    #TODO: handle when there is a lot of likes (not for now)
    render json: {result: {likes: shout.likes.reverse } }, status: 200
  end

  #Get user likes
  def user_likes
    Rails.logger.debug "BAB user_likes params: #{params}"

    likes = Like.where("created_at >= :max_age AND liker_id = :current_user_id", {max_age: max_age, current_user_id: current_user.id})

    #TODO: handle when there is a lot of likes (not for now)
    render json: {result: {likes: likes } }, status: 200
  end

private

  def like_params
    params.permit(:shout_id, :liker_id, :liker_username, :lat, :lng)
  end 
end