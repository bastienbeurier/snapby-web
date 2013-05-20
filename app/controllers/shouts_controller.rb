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
    Rails.logger.info "BAB zone_shouts params: #{params}"
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

  #Retrive most recent shouts for the feed with pagination
  def global_feed_shouts
    Rails.logger.info "BAB global_feed_shouts params: #{params}"

    per_page = params[:per_page] ? params[:per_page] : 20
    page = params[:page] ? params[:page] : 1

    shouts = Shout.where("source = 'native'").paginage(page: page, per_page: per_page).order('id DESC')

    respond_to do |format|
      format.json { render json: {result: shouts, status: 200} }
      format.html { render json: shouts }
    end
  end
end