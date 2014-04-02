class Api::V2::ActivitiesController < Api::V2::ApiController

  #Display likes for a shout
  def index
    Rails.logger.debug "BAB index activies index params: #{params}"

    render json: { result: {activities: current_user.activities.limit(100).reverse } }, status: 200
  end
end