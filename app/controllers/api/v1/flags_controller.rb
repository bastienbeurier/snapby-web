class Api::V1::FlagsController < Api::V1::ApiController

  #User flags an abusive snapby
  def create
    Rails.logger.debug "BAB report_snapby params: #{params}"

    snapby = Snapby.find(params[:snapby_id])
    
    if !snapby or !params[:motive]
      render :json => { :errors => { incomplete: ["incomplete information to flag snapby"] } }, status: 406
      return
    end

    existing_flags = Flag.where(snapby_id: snapby.id)

    #Case where this user already flagged this snapby
    if existing_flags.collect(&:flagger_id).include?(params[:flagger_id].to_i)
      render json: {errors: { duplicate: ["snapby already flagged by user"] } }, status: 422
      return
    else
      flag = Flag.new(flag_params)

      if flag.save
        #if more than 5 flags, do not display the snapby anymore
        if existing_flags.count >= 5
          snapby.update_attributes(removed: true)
        end

        #send mail
        begin
          UserMailer.flagged_snapby_email(flag,snapby).deliver
        rescue Exception => e
          Airbrake.notify(e)
        end
        
        render json: {result: { messages: ["snapby successfully flagged"] } }, status: 200
      else 
        render json: {errors: { internal: ["Failed to flag snapby"] } }, status: 500 
      end
    end
  end

private

  def flag_params
    params.permit(:snapby_id, :motive, :flagger_id)
  end 

end