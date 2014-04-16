class Api::V1::ActivitiesController < Api::V1::ApiController

  #Display likes for a snapby
  def index
    Rails.logger.debug "BAB index activies index params: #{params}"

    per_page = params[:page_size] ? params[:page_size] : 20
    page = params[:page] ? params[:page] : 1

    activities = current_user.activities.paginate(page: page, per_page: per_page).order('id DESC')

    render json: { result: {activities: activities } }, status: 200
  end

  def unread_activities_count
  	last_read = Time.now - params[:last_read].to_i.seconds

  	count = current_user.activities.where("created_at >= :last_read", { last_read: last_read }).count

  	render json: { result: {unread_activities_count: count } }, status: 200
  end
end