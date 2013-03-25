class ShoutsController < ApplicationController
  def create
    Rails.logger.info "BAB create params: #{params}"
    shout = Shout.new(lat: params[:lat], lng: params[:lng], description: params[:description])
    success = shout.save
    format.json { render :json => shout, status: :create }
  end

  def zone_shouts
    Rails.logger.info "BAB index params: #{params}"
    shouts = Shout.within(:within => params[:radius], :origin => [params[:lat], params[:lng]])
    format.json { render json: shouts, status: :ok }
  end
end
  