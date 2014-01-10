class Api::V2::PasswordsController < Devise::PasswordsController
  
  # Auth?

  #delete route
  def new
    render nothing:true
  end

  def create
    super
    # user = User.find_by(email: params[:email])
    # user.send_reset_password_instructions
    # render json: { result: { messages: ["Reset password instructions have been sent to #{user.email}."] } }, status: 201
  end

  def edit
     super
  end

  def update
    super
  end

end