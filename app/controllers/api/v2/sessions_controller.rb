class Api::V1::SessionsController < Api::V1::ApiController
	skip_before_filter :authenticate_user!, :only => :create

        def create
            user = User.find_for_database_authentication(:email => params[:email])

            if user && user.valid_password?(params[:password])
              user.ensure_authentication_token!
            else
              render :json => { :errors => ["Invalid email or password."] }, :status => :unauthorized
            end
        end

        def destroy
            user = User.where(authentication_token: params[:authentication_token]).first    
            user.reset_authentication_token!
            render :json => { :message => ["Session deleted."] }, :status => :ok
        end
end