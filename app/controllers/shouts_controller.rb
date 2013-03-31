class ShoutsController < ApplicationController

  #Create a shout
  def create
    Rails.logger.info "BAB create params: #{params}"
    
    shout = Shout.new(lat: params[:lat], lng: params[:lng], description: params[:description])
    success = shout.save

    respond_to do |format|
      format.json { render json: {result: shout, status: 201} }
      format.html { render shout.to_json }
    end
  end

  #Retrieve shouts within  a zone
  def zone_shouts
    Rails.logger.info "BAB index params: #{params}"

    shouts = Shout.within(:within => params[:radius], :origin => [params[:lat], params[:lng]]).limit(100)
    
    respond_to do |format|
      format.json { render json: {result: shouts, status: 200} }
      format.html { render shouts.to_json }
    end
  end
end
  