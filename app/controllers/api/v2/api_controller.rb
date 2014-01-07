class Api::V2::ApiController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  respond_to :json

  def obsolete_api
    Rails.logger.debug "TRUCHOV API_Version params: #{params}"
    if ! ACCEPTED_APIS.include?(params[:API_Version].to_f)
      render json: {result: "IsObsolete", status: 251}
    else
      render json: {result: "OK", status: 200}
    end
  end
end