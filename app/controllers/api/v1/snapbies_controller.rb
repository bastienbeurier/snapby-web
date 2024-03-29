class Api::V1::SnapbiesController < Api::V1::ApiController
  include ApplicationHelper
  skip_before_filter :authenticate_user!, :only => [:show, :bound_box_snapbies, :get_snapby_meta_data, :local_snapbies_count, :headblend]

  #Create a snapby
  def create
    if !params[:avatar] and !params[:image]
      render json: { errors: { invalid: ["snapby should contain a picture"] } }, :status => 500
    end

    params[:source] = "native"
    params[:user_id] = current_user.id
    params[:user_score] = current_user.liked_snapbies

    snapby = Snapby.new(snapby_params)

    snapby.anonymous = params[:anonymous] == "1"
    snapby.last_active = Time.now

    snapby.avatar = StringIO.new(Base64.decode64(params[:avatar]))

    if snapby.save
      current_user.update_attributes(snapby_count: current_user.snapbies.where("removed = 0").count)

      render json: { result: { snapby: snapby.response_snapby } }, status: 201
    else 
      render json: { errors: { internal: snapby.errors } }, :status => 500
    end
  end

  #Get snapby by id
  def show
    snapby = Snapby.find_by(id: params[:id])

    if snapby
      if snapby.anonymous
        snapby.username = ANONYMOUS_USERNAME
      end
      render json: { result: { snapby: snapby.response_snapby } }, status: 200
    else
      render json: { errors: { internal: ["failed to retrieve snapby"] } }, :status => 500
    end
  end

  #Retrieve snapbies within a zone (bouding box)
  def bound_box_snapbies
    per_page = params[:page_size] ? params[:page_size] : 20
    page = params[:page] ? params[:page] : 1

    snapbies = []
    
    snapbies = Snapby.where("removed = 0").in_bounds([[params[:swLat], params[:swLng]], [params[:neLat], params[:neLng]]]).order("last_active DESC").paginate(page: page, per_page: per_page)

    snapbies.each do |snapby|
      if snapby.anonymous
        snapby.username = ANONYMOUS_USERNAME
      end
    end
    render json: { result: { snapbies: Snapby.response_snapbies(snapbies), page: page } }, status: 200
  end

  def local_snapbies
    per_page = params[:page_size] ? params[:page_size] : 20
    page = params[:page] ? params[:page] : 1
    
    snapbies = Snapby.where("removed = 0").within(5, units: :kms, origin: [params[:lat], params[:lng]]).order("last_active DESC").paginate(page: page, per_page: per_page)

    snapbies.each do |snapby|
      if snapby.anonymous
        snapby.username = ANONYMOUS_USERNAME
      end
    end

    render json: { result: { snapbies: Snapby.response_snapbies(snapbies), page: page } }, status: 200
  end

  def local_snapbies_count
    snapbies_count = 0

    snapbies_count = Snapby.where("removed = 0").in_bounds([[params[:swLat], params[:swLng]], [params[:neLat], params[:neLng]]]).count

    render json: { result: { snapbies_count: snapbies_count } }, status: 200
  end

  # Remove snapby (for the snapbyer only)
  def remove
    snapby = Snapby.find(params[:snapby_id])
    if current_user.id == snapby.user_id or is_admin
      snapby.update_attributes(removed: true)
      snapbyer = User.find(snapby.user_id)
      snapbyer.update_attributes(snapby_count: snapbyer.snapbies.where("removed = 0").count)

      render json: { result: { messages: ["snapby successfully removed"] } }, status: 200
    else
      render json: { errors: { internal: ["The snapby does not belong to the current user"] } }, :status => 500
    end
  end

  def index 
    per_page = params[:page_size] ? params[:page_size] : 20
    page = params[:page] ? params[:page] : 1

    snapbies = []

    snapbies = User.find(params[:user_id]).snapbies.where("removed = 0").order('last_active DESC').paginate(page: page, per_page: per_page)

    render json: { result: { snapbies: Snapby.response_snapbies(snapbies) } }, status: 200
  end

  def headblend
    headblend = Headblend.new
    headblend.avatar = StringIO.new(Base64.decode64(params[:headblend]))  
    headblend.save
  end

private 
  def snapby_params
    params.permit(:lat, :lng, :username, :source, :user_id, :user_score)
  end
end