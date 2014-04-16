class SnapbiesController < ApplicationController

  # Get snapby by id
  # Still used for web sharing
  def show
    Rails.logger.debug "BAB show snapby params: #{params}"
    @snapby = Snapby.find_by(id: params[:id])

    if @snapby
      if @snapby.anonymous
        @snapby.username = ANONYMOUS_USERNAME
      end
      respond_to do |format|
        format.html
        format.json { render json: {result: @snapby}, status: 200 }
      end
    else
      respond_to do |format|
        format.json { render :json => { :errors => ["Failed to retrieve snapby"]}, :status => 500}
      end
    end
  end

  def obsolete_api
    Rails.logger.debug "TRUCHOV API_Version params: #{params}"
    if ! ACCEPTED_APIS.include?(params[:api_version].to_f)
      render json: {result: "IsObsolete", status: 251}
    else
      render json: {result: "OK", status: 200}
    end
  end
end