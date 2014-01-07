class Api::V2::FlagsController < Api::V2::ApiController

  #User flags an abusive shout
  def flag_shout
    Rails.logger.debug "BAB report_shout params: #{params}"

    shout = Shout.find(params[:shout_id])
    
    if !shout or !params[:user_id] or !params[:motive]
      respond_to do |format|
        format.json { render :json => { :errors => ["Incomplete information to flag shout"]}, :status => 406  }
      end
      return
    end

    flagged_shout = FlaggedShout.find_by_shout_id(params[:shout_id])

    #remove this array!
    # motives = ["abuse", "spam", "privacy", "inaccurate", "other"]

    #Case where the shout is flagged for the first time
    if !flagged_shout
      flagged_shout = FlaggedShout.new(flag_params)
    #Case where the shout has already been flagged, but never by that user
    elsif !flagged_shout.user_ids.split(",").include?(params[:user_id])
      flagged_shout.user_ids += "," + params[:user_id]
      #if more than 5 flags, automatically remove shout and add it to removed_shouts column in db
      if flagged_shout.user_ids.split(",").count >= 5
        removed_shout = RemovedShout.create(shout_id: shout.id,
                                            lat: shout.lat,
                                            lng: shout.lng,
                                            description: shout.description,
                                            display_name: shout.display_name,
                                            image: shout.image,
                                            source: shout.source, 
                                            shout_created_at: shout.created_at,
                                            user_id: shout.user_id,
                                            removed_by: "auto")
        shout.destroy
        flagged_shout.destroy
      end
    #Case where this user already flagged this shout
    else
      respond_to do |format|
        format.json { render json: {errors: ["Shout already flagged by user"]}, status: 422 }
      end
      return
    end

    #send mail (specified if automatically removed)

    if flagged_shout.save
      respond_to do |format|
        format.json { render json: {result: "Shout successfully flagged"}, status: 200 }
      end
    else 
      respond_to do |format|
        format.json { render json: {errors: ["Failed to flag shout"]}, status: 500 }
      end
    end
  end

private

  def flag_params
    params.permit(:shout_id, :user_id, :motive)
  end 

end