class ShoutsController < ApplicationController
  include DevelopmentTasks

  #Create a shout
  def create
    Rails.logger.debug "BAB create params: #{params}"

    params[:source] = "native"
    params[:display_name] = params[:user_name]

    shout = Shout.new(shout_params)
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

  #Get shout by id
  def show
    Rails.logger.debug "BAB show shout params: #{params}"
    shout = Shout.find(params[:id])

    if shout
      respond_to do |format|
        format.json { render json: {result: shout, status: 200} }
        format.html { render json: shout }
      end
    else
      respond_to do |format|
        format.json { render(:json => { :errors => "Failed to retrieve shout", :errorStatusCode => "Failed to retrieve shout" }, :status => 500) }
        format.html { render(:text => "Failed to retrieve shout", :status => 500) }
      end 
    end
  end

  #Retrieve shouts within a zone (bouding box)
  def bound_box_shouts
    Rails.logger.debug "BAB zone_shouts params: #{params}"
    max_age = Time.now - SHOUT_DURATION

    shouts = Shout.where("created_at >= :max_age", {:max_age => max_age}).in_bounds([[params[:swLat], params[:swLng]], [params[:neLat], params[:neLng]]]).limit(100).order("created_at DESC")
      
    Rails.logger.debug "BAB rbound_box_shouts response: #{shouts.collect(&:created_at)}"

    respond_to do |format|
      format.json { render json: {result: shouts, status: 200} }
      format.html { render json: shouts }
    end
  end

  #Not used anymore (for testing purposes)
  #Retrieve most recent shouts for the feed with pagination
  def global_feed_shouts
    Rails.logger.debug "BAB global_feed_shouts params: #{params}"

    per_page = params[:per_page] ? params[:per_page] : 100
    page = params[:page] ? params[:page] : 1

    max_age = Time.now - SHOUT_DURATION

    shouts = Shout.where("source = 'native' AND created_at >= :max_age", {:max_age => max_age}).paginate(page: page, per_page: per_page).order('id DESC')

    respond_to do |format|
      format.json { render json: {result: shouts, status: 200} }
      format.html { render json: shouts }
    end
  end

  #User flags an abusive shout
  def flag_shout
    Rails.logger.debug "BAB report_shout params: #{params}"

    shout = Shout.find(params[:id])
    
    if !shout or !params[:device_id] or !params[:motive]
      respond_to do |format|
        format.json { render(:json => { :errors => "Incomplete information to flag shout", :errorStatusCode => "Incomplete information to flag shout" }, :status => 406) }
        format.html { render(:text => "Incomplete information to flag shout", :status => 406) }
      end
      return
    end

    #todo later: check if not too many recent flags from this user (advised by Truchof)

    flagged_shout = FlaggedShout.find_by_shout_id(params[:id])

    motives = ["abuse", "spam", "privacy", "inaccurate", "other"]

    #Case where the shout is flagged for the first time
    if !flagged_shout
      params[:motive] = motives[params[:motive].to_i]
      params[:shout_id] = params[:id]
      flagged_shout = FlaggedShout.new(flag_params)
    #Case where the shout has already been flagged, but never by that user
    elsif !flagged_shout.device_id.split(",").include?(params[:device_id])
      flagged_shout.device_id += "," + params[:device_id]
      #if more than 5 flags, automatically remove shout and add it to removed_shouts column in db
      if flagged_shout.device_id.split(",").count >= 5
        removed_shout = RemovedShout.create(shout_id: shout.id,
                                            lat: shout.lat,
                                            lng: shout.lng,
                                            description: shout.description,
                                            display_name: shout.display_name,
                                            image: shout.image,
                                            source: shout.source, 
                                            shout_created_at: shout.created_at,
                                            device_id: shout.device_id,
                                            removed_by: "auto")
        shout.destroy
        flagged_shout.destroy
      end
    #Case where this user already flagged this shout
    else
      respond_to do |format|
        format.json { render json: {result: "Shout already flagged by user", status: 200} }
        format.html { render json: "Shout already flagged by user" }
      end
      return
    end

    #send mail (specified if automatically removed)

    if flagged_shout.save
      respond_to do |format|
        format.json { render json: {result: "Shout successfully flagged", status: 200} }
        format.html { render json: "Shout successfully flagged" }
      end
    else 
      respond_to do |format|
        format.json { render json: {result: "Failed to flag shout", status: 500} }
        format.html { render json: "Failed to flag shout" }
      end
    end
  end

  #For development only
  def demo
    if Rails.env.development?
      Shout.delete_all

      DevelopmentTasks.demo
    end

    respond_to do |format|
      format.json { render json: {result: "Demo ready to start", status: 200} }
      format.html { render json: "Demo ready to start" }
    end
  end

  def obsolete_api
    Rails.logger.info "TRUCH API_Version params: #{params}"
    if ! ACCEPTED_APIS.include?(params[:API_Version].to_f)
      render json: {result: "IsObsolete", status: 251}
    end
  end

private 

  def shout_params
    params.permit(:lat, :lng, :display_name, :description, :source, :device_id, :image)
  end

  def flag_params
    params.permit(:shout_id, :device_id, :motive)
  end

end