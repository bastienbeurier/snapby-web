class Api::V2::UsersController < Api::V2::ApiController
    skip_before_filter :authenticate_user!, :only => [:create]
end