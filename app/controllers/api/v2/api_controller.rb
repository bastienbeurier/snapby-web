class Api::V2::ApiController < DeviseController
  before_filter :authenticate_user!

  respond_to :json
end