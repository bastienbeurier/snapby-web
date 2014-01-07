class Api::V2::UsersController < Api::V2::ApiController

  respond_to :json

  def create
    user = User.new(user_params)

    if user.save
      render json: { result: user }, status: 201
    else
      render json: { :errors => user.errors }, status: 422
    end
  end

private 

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end