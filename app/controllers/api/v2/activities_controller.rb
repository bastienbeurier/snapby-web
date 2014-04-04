class Api::V2::ActivitiesController < Api::V2::ApiController

  #Display likes for a shout
  def index
    Rails.logger.debug "BAB index activies index params: #{params}"

    render json: { result: {activities: current_user.activities.limit(100).reverse } }, status: 200
  end

  def unread_activities_count
  	last_read = Time.now - params[:last_read].to_i.seconds

  	count = current_user.activities.where("created_at >= :last_read", { last_read: last_read }).count

  	render json: { result: {unread_activities_count: count } }, status: 200
  end
end