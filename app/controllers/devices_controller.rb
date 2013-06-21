class DevicesController < ApplicationController
  def update_device_info
    Rails.logger.info "BAB update_device_info: #{params}"

    if !params[:device_id] or !params[:push_token] or !params[:lat] or !params[:lng]
      respond_to do |format|
        format.json { render(:json => { :errors => "Incomplete device information", :errorStatusCode => "Incomplete device information" }, :status => 406) }
        format.html { render(:text => "Incomplete device information", :status => 406) }
      end
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
      device = Device.new(device_id: params[:device_id], 
                          push_token: params[:push_token], 
                          device_model: params[:device_model], 
                          os_version: params[:os_version], 
                          os_type: params[:os_type], 
                          app_version: params[:app_version], 
                          api_version: params[:api_version], 
                          lat: params[:lat], 
                          lng: params[:lng])
    end

    
    success = device.save

    if success
      respond_to do |format|
        format.json { render json: {result: device, status: 201} }
        format.html { render json: device }
      end
    else 
      respond_to do |format|
        format.json { render(:json => { :errors => "Failed to save device", :errorStatusCode => "Failed to save shout" }, :status => 500) }
        format.html { render(:text => "Failed to save device", :status => 500) }
      end 
    end
  end
end
