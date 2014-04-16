class HomeController < ApplicationController
  caches_page :index

  #Website splash page
  def index
  end

  def about
  end

  def privacy
  end

  def terms
  end

  def contact
  end

  #For testing purposes
  #Retrieve most recent snapbies for the feed with pagination
  def global_feed_snapbies
    Rails.logger.debug "BAB global_feed_snapbies params: #{params}"

    per_page = params[:per_page] ? params[:per_page] : 100
    page = params[:page] ? params[:page] : 1

    max_age = Time.now - SNAPBY_DURATION

    snapbies = Snapby.where("source = 'native' AND created_at >= :max_age", {:max_age => max_age}).paginate(page: page, per_page: per_page).order('id DESC')

    render json: {result: snapbies}, status: 200
  end
end
