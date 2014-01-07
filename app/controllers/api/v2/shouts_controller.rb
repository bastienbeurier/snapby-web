class Api::V2::ShoutsController < Api::V2::ApiController
  skip_before_filter :authenticate_user!, :only => :global_feed_shouts, :show, :bound_box_shouts

  #Create a shout
  def create
    Rails.logger.debug "BAB create params: #{params}"

    params[:source] = "native"
    params[:user_id] = current_user.id

    shout = Shout.new(shout_params)
    success = shout.save

    if success
      respond_to do |format|
        format.json { render json: {result: { shout: shout } }, status: 201 }
      end
    else 
      respond_to do |format|
        format.json { render :json => { :errors => ["Failed to save shout"] }, :status => 500 }
      end 
    end
  end

  #Get shout by id
  def show
    Rails.logger.debug "BAB show shout params: #{params}"
    shout = Shout.find(params[:id])

    if shout
      respond_to do |format|
        format.json { render json: {result: { shout: shout } }, status: 200 }
      end
    else
      respond_to do |format|
        format.json { render :json => { :errors => ["Failed to retrieve shout"]}, :status => 500  }
      end 
    end
  end

  #Retrieve shouts within a zone (bouding box)
  def bound_box_shouts
    Rails.logger.debug "BAB zone_shouts params: #{params}"
    max_age = Time.now - SHOUT_DURATION

    shouts = Shout.where("created_at >= :max_age", {:max_age => max_age}).in_bounds([[params[:swLat], params[:swLng]], [params[:neLat], params[:neLng]]]).limit(100).order("created_at DESC")

    respond_to do |format|
      format.json { render json: {result: {shouts: shouts } }, status: 200 }
    end
  end

private 

  def shout_params
    params.permit(:lat, :lng, :username, :description, :source, :user_id, :image)
  end
end