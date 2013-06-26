module PushNotification
	def self.notify_new_shout(shout)
		# devices = Device.within(DEFAULT_NOTIFICATION_RADIUS , :origin => [shout.lat, shout.lng]).where("notification_radius != 0 AND device_id != :shout_device_id", {shout_device_id: shout.device_id})
    
	    devices = []

	    if Rails.env.development?
	      	devices = Device.where("notification_radius != 0")
	    else
	      	devices = Device.where("notification_radius != 0 AND device_id != :shout_device_id", {shout_device_id: shout.device_id})
	    end

	  	push_tokens = devices.map { |device| device.push_token }
	  	begin
	  	  	Urbanairship.push({apids: push_tokens, android: {alert: '"' + shout.description + '"', extra: {shout: shout.to_json}}})
	  	rescue Exception => e
	  	end
	end	
end	