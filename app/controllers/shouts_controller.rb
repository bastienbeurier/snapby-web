class ShoutsController < ApplicationController
  def create_shout
    Rails.logger.info "BAB #{params}"
    shout = Shout.new(params[:shout])
    shout.save
    render :json => shout
  end

  def index
    Rails.logger.info "BAB #{params}"
    shouts = Shout.within(:within => params[:radius], :origin => [params[:lat], params[:lng]])
    render :json => shouts
  end
end
  