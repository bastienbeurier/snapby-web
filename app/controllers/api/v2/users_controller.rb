class Api::V2::UsersController < Api::V2::ApiController
  skip_before_filter :authenticate_user!, :only => [:create]

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