class Api::V2::FlagsController < Api::V2::ApiController

  #User flags an abusive shout
  def flag_shout
    Rails.logger.debug "BAB report_shout params: #{params}"

    shout = Shout.find(params[:shout_id])
    
    if !shout or !params[:motive]
      render :json => { :errors => ["Incomplete information to flag shout"]}, :status => 406
      return
    end

    existing_flags = Flag.find_by(shout_id: shout.id)

    #Case where this user already flagged this shout
    if existing_flags.find_by(flagger_id: flag.flagger_id)
      format.json { render json: {errors: ["Shout already flagged by user"]}, status: 422
      return
    else
      flag = Flag.new(flag_params)
      #if more than 5 flags, do not display the shout anymore
      if existing_flags.count >= 4
        shout.update_attributes(removed: true)
      end

      #send mail (specified if automatically removed)
      UserMailer.flagged_shout_email(flag,shout).deliver

      if flag.save
        format.json { render json: {message: "Shout successfully flagged"}, status: 200
      else 
        format.json { render json: {errors: ["Failed to flag shout"]}, status: 500
      end
    end
  end

private

  def flag_params
    params.permit(:shout_id, :motive, :flagger_id)
  end 

end