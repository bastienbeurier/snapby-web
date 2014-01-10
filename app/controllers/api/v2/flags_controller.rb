class Api::V2::FlagsController < Api::V2::ApiController

  #User flags an abusive shout
  def create
    Rails.logger.debug "BAB report_shout params: #{params}"

    shout = Shout.find(params[:shout_id])
    
    if !shout or !params[:motive]
      render :json => { :errors => { incomplete: ["incomplete information to flag shout"] } }, status: 406
      return
    end

    existing_flags = Flag.find_by(shout_id: shout.id)

    #Case where this user already flagged this shout
    if existing_flags.find_by(flagger_id: params[:flagger_id])
      render json: {errors: { duplicate: ["shout already flagged by user"] } }, status: 422
      return
    else
      flag = Flag.new(flag_params)

      if flag.save
        #if more than 5 flags, do not display the shout anymore
        if existing_flags.count >= 5
          shout.update_attributes(removed: true)
        end

        #send mail (specified if automatically removed)
        UserMailer.flagged_shout_email(flag,shout).deliver

        render json: {result: { messages: ["shout successfully flagged"] } }, status: 200
      else 
        render json: {errors: { internal: ["Failed to flag shout"] } }, status: 500 
      end
    end
  end

private

  def flag_params
    params.permit(:shout_id, :motive, :flagger_id)
  end 

end