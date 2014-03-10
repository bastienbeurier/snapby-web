class Api::V2::RelationshipsController < Api::V2::ApiController

  def create
    if  current_user.id == params[:followed_id].to_i
      render json: { errors: { internal: ["User can't follow himself"] } }, :status => 500
    else
      user = User.find(params[:followed_id])
      current_user.follow!(user)
      render json: { result: { messages: ["Relationship successfully created"] } }, status: 201
    end
  end

  def destroy
    followed_user = User.find(params[:followed_id])
    current_user.unfollow!(followed_user)
    render json: { result: { messages: ["Relationship successfully destroyed"] } }, status: 201
  end
end