class Api::V1::SnapbysController < Api::V1::ApiController
  include ApplicationHelper
  skip_before_filter :authenticate_user!, :only => [:show, :bound_box_snapbys, :get_snapby_meta_data, :local_snapbys_count]

  #Create a snapby
  def create
    if !params[:avatar] and !params[:image]
      render json: { errors: { invalid: ["snapby should contain a picture"] } }, :status => 500
    end

    params[:source] = "native"
    params[:user_id] = current_user.id

    snapby = Snapby.new(snapby_params)

    snapby.anonymous = params[:anonymous] == "1"

    snapby.avatar = StringIO.new(Base64.decode64(params[:avatar]))

    if snapby.save
      # update snapby_count
      if !snapby.anonymous
        snapby.user.update_attributes(snapby_count: snapby.user.snapby_count + 1)
      end

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

  #Get snapby meta data
  def get_snapby_meta_data
    snapby = Snapby.find(params[:snapby_id])

    if !snapby
      render json: { errors: { invalid: ["wrong snapby id"] } }, :status => 406
    end

    render json: { result: { comment_count: snapby.comments.length, liker_ids: snapby.likes.collect(&:liker_id)} }, status: 200
  end

  #Retrieve snapbys within a zone (bouding box)
  def bound_box_snapbys
    snapbys = []
    
    if Rails.env.development?
      snapbys = Snapby.where("removed = 0").in_bounds([[params[:swLat], params[:swLng]], [params[:neLat], params[:neLng]]]).limit(10).order("created_at DESC")
    else
      snapbys = Snapby.where("removed = 0").in_bounds([[params[:swLat], params[:swLng]], [params[:neLat], params[:neLng]]]).limit(10).order("created_at DESC")
    end

    snapbys.each do |snapby|
      if snapby.anonymous
        snapby.username = ANONYMOUS_USERNAME
      end
    end
    render json: { result: { snapbys: Snapby.response_snapbys(snapbys) } }, status: 200
  end

  def local_snapbys_count
    snapbys_count = 0

    if Rails.env.development?
      snapbys_count = Snapby.where("removed = 0").in_bounds([[params[:swLat], params[:swLng]], [params[:neLat], params[:neLng]]]).count
    else
      snapbys_count = Snapby.where("removed = 0").in_bounds([[params[:swLat], params[:swLng]], [params[:neLat], params[:neLng]]]).count
    end

    render json: { result: { snapbys_count: snapbys_count } }, status: 200
  end

  def local_snapbys
    per_page = params[:page_size] ? params[:page_size] : 20
    page = params[:page] ? params[:page] : 1

    snapbys = []

    if Rails.env.development?
      snapbys = Snapby.where("removed = 0").in_bounds([[params[:swLat], params[:swLng]], [params[:neLat], params[:neLng]]]).paginate(page: page, per_page: per_page).order("created_at DESC")
    else
      snapbys = Snapby.where("removed = 0").in_bounds([[params[:swLat], params[:swLng]], [params[:neLat], params[:neLng]]]).paginate(page: page, per_page: per_page).order("created_at DESC")
    end

    snapbys.each do |snapby|
      if snapby.anonymous
        snapby.username = ANONYMOUS_USERNAME
      end
    end

    render json: { result: { snapbys: Snapby.response_snapbys(snapbys), page: page } }, status: 200
  end

  # Remove snapby (for the snapbyer only)
  def remove
    snapby = Snapby.find(params[:snapby_id])
    if current_user.id == snapby.user_id or is_admin
      snapby.update_attributes(removed: true)
      render json: { result: { messages: ["snapby successfully removed"] } }, status: 200
    else
      render json: { errors: { internal: ["The snapby does not belong to the current user"] } }, :status => 500
    end
  end

  def trending
    snapby = Snapby.find(params[:snapby_id])
    if is_admin
      snapby.make_trending
      render json: { result: { messages: ["Trended baby"] } }, status: 200
    end
  end

  def index 
    per_page = params[:page_size] ? params[:page_size] : 20
    page = params[:page] ? params[:page] : 1

    snapbys = []

    if Rails.env.development?
      snapbys = User.find(params[:user_id]).snapbys.where("removed = 0").paginate(page: page, per_page: per_page).order('id DESC')
    else
      snapbys = User.find(params[:user_id]).snapbys.where("removed = 0").paginate(page: page, per_page: per_page).order('id DESC')
    end

    render json: { result: { snapbys: Snapby.response_snapbys(snapbys) } }, status: 200
  end

private 

  def snapby_params
    params.permit(:lat, :lng, :username, :description, :source, :user_id, :image)
  end
end