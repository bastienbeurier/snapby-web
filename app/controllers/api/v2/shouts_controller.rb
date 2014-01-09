class Api::V2::ShoutsController < Api::V2::ApiController
  skip_before_filter :authenticate_user!, :only => [:show, :bound_box_shouts]

  #Create a shout
  def create
    Rails.logger.debug "BAB create params: #{params}"

    params[:source] = "native"
    params[:user_id] = current_user.id

    shout = Shout.new(shout_params)

    if shout.save
      render json: { result: { shout: shout } }, status: 201
    else 
      render json: { errors: { internal: shout.errors } }, :status => 500
    end
  end

  #Get shout by id
  def show
    Rails.logger.debug "BAB show shout params: #{params}"
    shout = Shout.find(params[:id])

    if shout
      render json: { result: { shout: shout } }, status: 200
    else
      render json: { errors: { internal: ["failed to retrieve shout"] } }, :status => 500
    end
  end

  #Retrieve shouts within a zone (bouding box)
  def bound_box_shouts
    Rails.logger.debug "BAB zone_shouts params: #{params}"
    max_age = Time.now - SHOUT_DURATION

    shouts = Shout.where("created_at >= :max_age", {:max_age => max_age}).in_bounds([[params[:swLat], params[:swLng]], [params[:neLat], params[:neLng]]]).limit(100).order("created_at DESC")

    render json: {result: {shouts: shouts } }, status: 200
  end

private 

  def shout_params
    params.permit(:lat, :lng, :username, :description, :source, :user_id, :image)
  end
end