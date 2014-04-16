class Api::V1::CommentsController < Api::V1::ApiController

  #User creates comments
  def create
    Rails.logger.debug "BAB create comment params: #{params}"

    params[:commenter_id] = current_user.id
    params[:commenter_username] = current_user.username

    comment = Comment.new(comment_params)

    if comment.save
      snapby = Snapby.find(params[:snapby_id])
      snapby.update_attributes(comment_count: snapby.comment_count + 1)
      render json: { result: { comments: snapby.comments.reverse } }, status: 201
    else 
      render json: { errors: { internal: comment.errors } }, :status => 500
    end
  end

  #Display comments for a snapby
  def index
    Rails.logger.debug "BAB comment index params: #{params}"

    if !params[:snapby_id]
      render json: { errors: {incomplete: ["Incomplete comment information"] } }, :status => 406
      return
    end

    snapby = Snapby.find(params[:snapby_id])

    #TODO: handle when there is a lot of comments (not for now)
    render json: {result: {comments: snapby.comments.reverse } }, status: 200
  end

private

  def comment_params
    params.permit(:snapby_id, :snapbyer_id, :description, :commenter_id, :commenter_username, :lat, :lng)
  end 

end