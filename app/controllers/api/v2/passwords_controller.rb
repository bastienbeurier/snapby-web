class Api::V2::PasswordsController < Api::V2::ApiController
  skip_before_filter :authenticate_user!, :only => :create


  def create
    user = User.find_by(email: params[:email])
    user.send_reset_password_instructions
    render json: { result: { messages: ["Reset password instructions have been sent to #{user.email}."] } }, status: 201
  end

  def update

  end

end