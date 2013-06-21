class ShoutObserver < ActiveRecord::Observer
  # Find a way to include module and move code to this module
  # include PushNotification

  def after_create(shout)
    # devices = Device.within(10, :origin => [shout.lat, shout.lng]).where("notification_radius != 0 AND device_id != :shout_device_id", {shout_device_id: shout.device_id})
    devices = Device.where("notification_radius != 0 AND device_id != :shout_device_id", {shout_device_id: shout.device_id})

	push_tokens = devices.map { |device| device.push_token }

	begin
	  	Urbanairship.push({apids: push_tokens, android: {alert: '"' + shout.description + '"'}})
	rescue Exception => e
	end
  end
end