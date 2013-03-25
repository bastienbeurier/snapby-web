class ShoutsController < ApplicationController
  def create
    Rails.logger.info "BAB create params: #{params}"
    shout = Shout.new(lat: params[:lat], lng: params[:lng], description: params[:description])
    success = shout.save
    format.json { render :json => shout.to_json }
  end

  def zone_shouts
    Rails.logger.info "BAB index params: #{params}"
    shouts = Shout.within(:within => params[:radius], :origin => [params[:lat], params[:lng]])
    Rails.logger.info "BAB shouts: #{shouts}"
    Rails.logger.info "BAB length: #{shouts.length}"
    format.json { render :json => shouts.to_json }
  end
end
  