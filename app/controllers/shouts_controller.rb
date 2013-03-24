class ShoutsController < ApplicationController
  def create
    Rails.logger.info "BAB params: #{params}"
    shout = Shout.new(params[:shout])
    success = shout.save
    Rails.logger.info "BAB shout: #{shout}"
    Rails.logger.info "BAB success? #{success}"
    render :json => shout
  end

  def index
    Rails.logger.info "BAB #{params}"
    shouts = Shout.within(:within => params[:radius], :origin => [params[:lat], params[:lng]])
    render :json => shouts
  end
end
  