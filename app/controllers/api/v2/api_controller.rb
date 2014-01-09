class Api::V2::ApiController < ApplicationController
  before_action :authenticate_user!

  skip_before_filter :authenticate_user!, :only => :obsolete_api

  respond_to :json

  def authenticate_user!
    unless current_user
      render :json => { errors: ["Authentication error"] }, :status => 401
    end
  end

  def obsolete_api
    Rails.logger.debug "TRUCHOV API_Version params: #{params}"
    if !ACCEPTED_APIS.include?(params[:API_Version].to_f)
      render json: {result: { obsolete: "true" } }, status: 200
    else
      render json: {result: { obsolete: "false" } }, status: 200
    end
  end
end