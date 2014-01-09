class Api::V2::SessionsController < Api::V2::ApiController
  skip_before_filter :authenticate_user!, :only => :create

  def create
    user = User.find_for_database_authentication(:email => params[:email])

    if user && user.valid_password?(params[:password])
      user.ensure_authentication_token!
      render json: { result: { user: user, auth_token: user.authentication_token} }, status: 200
    else
      render json: { errors: { authentication: ["invalid email or password"] } }, status: 401
    end
  end

  def destroy
    user = User.where(authentication_token: params[:auth_token]).first    
    user.reset_authentication_token!
    render json: { result: { messages: ["session deleted"] } }, status: 200
  end
end