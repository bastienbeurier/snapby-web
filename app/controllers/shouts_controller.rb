class ShoutsController < ApplicationController

  #Create a shout
  def create
    Rails.logger.info "BAB create params: #{params}"
    
    shout = Shout.new(lat: params[:lat], lng: params[:lng], description: params[:description], source: "native")
    success = shout.save

    respond_to do |format|
      format.json { render json: {result: shout, status: 201} }
      format.html { render json: shout }
    end
  end

  #Retrieve shouts within  a zone
  def zone_shouts
    Rails.logger.info "BAB index params: #{params}"
    one_day_ago = Time.now - 1.day

    shouts = Shout.within(:within => params[:radius], :origin => [params[:lat], params[:lng]]).where("created_at >= :one_day_ago", {:one_day_ago => one_day_ago}).limit(100)

    respond_to do |format|
      format.json { render json: {result: shouts, status: 200} }
      format.html { render json: shouts }
    end
  end
end
  