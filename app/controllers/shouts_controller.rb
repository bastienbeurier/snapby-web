class ShoutsController < ApplicationController
  def create
    Rails.logger.info "BAB create params: #{params}"
    shout = Shout.new(lat: params[:lat], lng: params[:lng], description: params[:description])
    success = shout.save
    shout
  end

  def zone_shouts
    Rails.logger.info "BAB index params: #{params}"
    shouts = Shout.within(:within => params[:radius], :origin => [params[:lat], params[:lng]])
    shouts
  end
end
  