class DevicesController < ApplicationController
  #Store info about the user device (only devices that can receive push notification)
  def update_device_info
    Rails.logger.debug "BAB update_device_info: #{params}"

    if !params[:device_id] or !params[:push_token]
      render json: { :errors => ["Incomplete device information"] }, :status => 406
      return
    end

    device = Device.find_by_device_id(params[:device_id])

    if device 
      device.push_token = params[:push_token]
      device.os_version = params[:os_version]
      device.app_version = params[:app_version]
      device.api_version = params[:api_version]
      device.notification_radius = params[:notification_radius] ? params[:notification_radius] : -1
      
      if params[:lat] and params[:lng]
        device.lat = params[:lat]
        device.lng = params[:lng]
      end
    else
      if !params[:lat] or !params[:lng]
        render json: { :errors => ["Incomplete device information"] }, :status => 406
        return
      end

      device = Device.new(device_params)
    end

    
    success = device.save

    if success
      render json: { result: device }, status: 201
    else 
      render json: { :errors => ["Failed to save device"] }, :status => 500 
    end
  end

  #Get black listed devices
  def black_listed_devices
    black_listed_devices = BlackListedDevice.all

    render json: { result: black_listed_devices }, status: 200
  end

  private

  def device_params
    params.permit(:device_id, :push_token, :device_model, :os_version, :os_type, :app_version, :api_version, :lat, :lng, :notification_radius)
  end
end
