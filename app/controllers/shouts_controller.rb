class ShoutsController < ApplicationController

  #Create a shout
  def create
    Rails.logger.info "BAB create params: #{params}"
    
    shout = Shout.new(lat: params[:lat], lng: params[:lng], description: params[:description])
    success = shout.save

    respond_to do |format|
      format.json { render json: {result: shout, status: 201} }
    end
  end

  #Retrieve shouts within  a zone
  def zone_shouts
    Rails.logger.info "BAB index params: #{params}"

    shouts = Shout.within(:within => params[:radius], :origin => [params[:lat], params[:lng]])
    
    respond_to do |format|
      format.json { render json: {result: shouts, status: 200} }
    end
  end
end
  