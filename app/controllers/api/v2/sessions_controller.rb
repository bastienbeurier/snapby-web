class Api::V2::SessionsController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  respond_to :json

  def create
    user = User.find_for_database_authentication(:email => params[:email])

    if user && user.valid_password?(params[:password])
      user.ensure_authentication_token!
      render :json => { :result => user }, :status => :ok
    else
      render :json => { :errors => ["Invalid email or password."] }, :status => :unauthorized
    end
  end

  def destroy
    user = User.where(authentication_token: params[:auth_token]).first    
    user.reset_authentication_token!
    render :json => { :message => ["Session deleted."] }, :status => :ok
  end
end