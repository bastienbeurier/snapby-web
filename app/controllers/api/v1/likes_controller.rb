class Api::V1::LikesController < Api::V1::ApiController

  #User creates like
  def create
    Rails.logger.debug "BAB create like params: #{params}"

    params[:liker_id] = current_user.id
    params[:liker_username] = current_user.username

    snapby = Snapby.find(params[:snapby_id])

    if snapby.likes.collect(&:liker_id).include? current_user.id
      render json: { errors: { invalid: ["Snapby already liked by user"] } }, :status => 406
      return
    end

    like = Like.new(like_params)  
    
    if like.save
      # update counter in snapby
      snapby.update_attributes(like_count: snapby.like_count + 1, last_active: Time.now)

      snapbyer = User.find(snapby.user_id)
      snapbyer.update_attributes(liked_snapbies: snapbyer.liked_snapbies + 1)

      CreateLikeActivityAndNotificationWorker.perform_async(like.id)
      UpdateUserScoreWorker.perform_async(snapbyer.id)

      render json: { result: { like_count: snapby.like_count } }, status: 201
    else 
      render json: { errors: { internal: like.errors } }, :status => 500
    end
  end

  def destroy
    Rails.logger.debug "TRUCHOV remove_likes params: #{params}"
 
    likes = Like.where("liker_id = ? AND snapby_id =?", current_user.id, params[:snapby_id])

    if likes.count < 1
      render json: { errors: { internal: ["User did not like this snapby"] } }, :status => 500
      return
    end

    like = likes[0]

    if like.destroy
      snapby = Snapby.find(params[:snapby_id])
      snapby.update_attributes(like_count: snapby.like_count - 1)

      snapbyer = User.find(snapby.user_id)
      snapbyer.update_attributes(liked_snapbies: snapbyer.liked_snapbies - 1)

      UpdateUserScoreWorker.perform_async(snapbyer.id)

      render json: { result: { messages: ["Like successfully destroyed"] } }, status: 200
    else
      render json: { errors: { internal: ["User did not like this snapby"] } }, :status => 500
    end
  end

private

  def like_params
    params.permit(:snapby_id, :liker_id, :liker_username, :lat, :lng)
  end 
end