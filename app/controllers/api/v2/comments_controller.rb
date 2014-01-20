class Api::V2::CommentsController < Api::V2::ApiController

  #User creates comments
  def create
    Rails.logger.debug "BAB create comment params: #{params}"

    comment = Comment.new(comment_params)

    if comment.save
      render json: { result: { comment: comment } }, status: 201
    else 
      render json: { errors: { internal: comment.errors } }, :status => 500
    end
  end

  #Display comments for a shout
  def index
    Rails.logger.debug "BAB comment index params: #{params}"

    if !params[:shout_id]
      render json: { errors: {incomplete: ["Incomplete comment information"] } }, :status => 406
      return
    end

    #TODO: handle when there is a lot of comments (not for now)
    comments = Comment.where("shout_id = :shout_id", {:shout_id => params[:shout_id]}).limit(100).order("created_at DESC")

    render json: {result: {comments: comments } }, status: 200
  end

private

  def comment_params
    params.permit(:shout_id, :shouter_id, :description, :commenter_id, :commenter_username, :lat, :lng)
  end 

end