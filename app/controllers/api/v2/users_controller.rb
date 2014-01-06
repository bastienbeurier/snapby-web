class Api::V1::UsersController < Api::V1::ApiController
    skip_before_filter :authenticate_user!, :only => [:create]
end