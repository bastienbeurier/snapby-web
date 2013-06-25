class ShoutsController < ApplicationController
  include DevelopmentTasks::Demo

  #Create a shout
  def create
    Rails.logger.debug "BAB create params: #{params}"

    shout = Shout.new(lat: params[:lat], lng: params[:lng], display_name: params[:user_name], description: params[:description], source: "native", device_id: params[:device_id])
    success = shout.save

    if success
      respond_to do |format|
        format.json { render json: {result: shout, status: 201} }
        format.html { render json: shout }
      end
    else 
      respond_to do |format|
        format.json { render(:json => { :errors => "Failed to save shout", :errorStatusCode => "Failed to save shout" }, :status => 500) }
        format.html { render(:text => "Failed to save shout", :status => 500) }
      end 
    end
  end

  #Retrieve shouts within a zone (location and radius)
  def zone_shouts
    Rails.logger.debug "BAB zone_shouts params: #{params}"
    max_age = Time.now - SHOUT_DURATION

    if params[:notwitter].to_i == 1
      shouts = Shout.where("source = 'native' AND created_at >= :max_age", {:max_age => max_age}).within(params[:radius].to_i, :origin => [params[:lat], params[:lng]]).limit(100).order("created_at DESC")
    else 
      shouts = Shout.where("created_at >= :max_age", {:max_age => max_age}).within(params[:radius].to_i, :origin => [params[:lat], params[:lng]]).limit(100).order("created_at DESC")
    end

    respond_to do |format|
      format.json { render json: {result: shouts, status: 200} }
      format.html { render json: shouts }
    end
  end

  #Retrieve shouts within a zone (bouding box)
  def bound_box_shouts
    Rails.logger.debug "BAB zone_shouts params: #{params}"
    max_age = Time.now - SHOUT_DURATION

    shouts = Shout.where("created_at >= :max_age", {:max_age => max_age}).in_bounds([[params[:swLat], params[:swLng]], [params[:neLat], params[:neLng]]]).limit(100).order("created_at DESC")

    Rails.logger.info "BAB request response length: #{shouts.length}"

    respond_to do |format|
      format.json { render json: {result: shouts, status: 200} }
      format.html { render json: shouts }
    end
  end

  #Not used anymore (for testing purposes)
  #Retrieve most recent shouts for the feed with pagination
  def global_feed_shouts
    Rails.logger.debug "BAB global_feed_shouts params: #{params}"

    per_page = params[:per_page] ? params[:per_page] : 20
    page = params[:page] ? params[:page] : 1

    max_age = Time.now - SHOUT_DURATION

    shouts = Shout.where("source = 'native' AND created_at >= :max_age", {:max_age => max_age}).paginate(page: page, per_page: per_page).order('id DESC')

    respond_to do |format|
      format.json { render json: {result: shouts, status: 200} }
      format.html { render json: shouts }
    end
  end

  def start_demo
    if Rails.env.development?
      Shout.delete_all

      DevelopmentTasks::Demo.start_demo
    end

    respond_to do |format|
      format.json { render json: {result: "Demo ready to start", status: 200} }
      format.html { render json: "Demo ready to start" }
    end
  end
end