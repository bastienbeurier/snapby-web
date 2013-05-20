class ShoutsController < ApplicationController

  #Create a shout
  def create
    Rails.logger.info "BAB create params: #{params}"
    
    shout = Shout.new(lat: params[:lat], lng: params[:lng], display_name: params[:user_name], description: params[:description], source: "native")
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

    if params[:notwitter].to_i == 1
      shouts = Shout.where("source = 'native' AND created_at >= :one_day_ago", {:one_day_ago => one_day_ago}).within(params[:radius].to_i, :origin => [params[:lat], params[:lng]]).limit(100)
    else 
      shouts = Shout.where("created_at >= :one_day_ago", {:one_day_ago => one_day_ago}).within(params[:radius].to_i, :origin => [params[:lat], params[:lng]]).limit(100)
    end

    respond_to do |format|
      format.json { render json: {result: shouts, status: 200} }
      format.html { render json: shouts }
    end
  end
end