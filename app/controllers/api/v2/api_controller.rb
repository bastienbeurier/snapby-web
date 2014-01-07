class Api::V2::ApiController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  respond_to :json
end