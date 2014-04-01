class Api::V2::ShoutsController < Api::V2::ApiController
  include ApplicationHelper
  skip_before_filter :authenticate_user!, :only => [:show, :bound_box_shouts, :get_shout_meta_data]

  #Create a shout
  def create
    Rails.logger.debug "BAB create params: #{params}"

    if !params[:avatar] and !params[:image]
      render json: { errors: { invalid: ["shout should contain a picture"] } }, :status => 500
    end

    params[:source] = "native"
    params[:user_id] = current_user.id

    shout = Shout.new(shout_params)

    shout.anonymous = params[:anonymous] == "1"
    shout.trending = params[:trending] == "1"

    avatar = nil

    if params[:avatar]
      avatar = StringIO.new(Base64.decode64(params[:avatar]))
    else
      #For retrocompatibility, remove when we can
      avatar = open(URI.parse(process_uri("http://#{shout.image}--400")))
    end

    shout.avatar = avatar

    if shout.save
      # update shout_count
      if !shout.anonymous
        shout.user.update_attributes(shout_count: shout.user.shout_count + 1)
      end

      #For retrocompatibility, remove when we can
      if Rails.env.development?
        shout.update_attributes(image: "s3.amazonaws.com/shout_development/original/image_#{shout.id.to_s}")
      else
        shout.update_attributes(image: "s3.amazonaws.com/shout_production1/original/image_#{shout.id.to_s}") 
      end

      render json: { result: { shout: shout } }, status: 201
    else 
      render json: { errors: { internal: shout.errors } }, :status => 500
    end
  end

  #Get shout by id
  def show
    Rails.logger.debug "BAB show shout params: #{params}"
    shout = Shout.find_by(id: params[:id])

    if shout
      if shout.anonymous
        shout.username = ANONYMOUS_USERNAME
      end
      render json: { result: { shout: shout } }, status: 200
    else
      render json: { errors: { internal: ["failed to retrieve shout"] } }, :status => 500
    end
  end

  #Get shout meta data
  def get_shout_meta_data
    Rails.logger.debug "BAB get shout meta data: #{params}"
    shout = Shout.find(params[:shout_id])

    if !shout
      render json: { errors: { invalid: ["wrong shout id"] } }, :status => 406
    end

    render json: { result: { comment_count: shout.comments.length, liker_ids: shout.likes.collect(&:liker_id)} }, status: 200
  end

  #Retrieve shouts within a zone (bouding box)
  def bound_box_shouts
    Rails.logger.debug "BAB zone_shouts params: #{params}"
    max_age = Time.now - SHOUT_DURATION

    shouts = Shout.where("created_at >= :max_age", {:max_age => max_age}).in_bounds([[params[:swLat], params[:swLng]], [params[:neLat], params[:neLng]]]).limit(20).order("created_at DESC")

    shouts.each do |shout|
      if shout.anonymous
        shout.username = ANONYMOUS_USERNAME
      end
    end
    render json: { result: { shouts: Shout.response_shouts(shouts) } }, status: 200
  end

  # Remove shout (for the shouter only)
  def remove
    Rails.logger.debug "TRUCHOV remove_shouts params: #{params}"
    shout = Shout.find(params[:shout_id])
    if current_user.id == shout.user_id or is_admin
      shout.update_attributes(removed: true)
      render json: { result: { messages: ["shout successfully removed"] } }, status: 200
    else
      render json: { errors: { internal: ["The shout does not belong to the current user"] } }, :status => 500
    end
  end

  def trending
    shout = Shout.find(params[:shout_id])
    if is_admin
      shout.make_trending
      render json: { result: { messages: ["Trended baby"] } }, status: 200
    end
  end

private 

  def shout_params
    params.permit(:lat, :lng, :username, :description, :source, :user_id, :image)
  end
end