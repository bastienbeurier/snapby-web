module PushNotification
	def self.notify_new_shout(shout)
	    devices = []

	    if Rails.env.development?
	      	devices = Device.within(NOTIFICATION_RADIUS_1 , :origin => [shout.lat, shout.lng]).where("notification_radius = 1")
	      	devices += Device.within(NOTIFICATION_RADIUS_2 , :origin => [shout.lat, shout.lng]).where("notification_radius = 2")
	      	devices += Device.within(NOTIFICATION_RADIUS_3 , :origin => [shout.lat, shout.lng]).where("notification_radius = -1 OR notification_radius = 3")
	    else
	    	devices = Device.where("device_id != :shout_device_id", {shout_device_id: shout.device_id})
	      	# devices = Device.within(NOTIFICATION_RADIUS_1 , :origin => [shout.lat, shout.lng]).where("notification_radius = 1 AND device_id != :shout_device_id", {shout_device_id: shout.device_id})
	      	# devices += Device.within(NOTIFICATION_RADIUS_2 , :origin => [shout.lat, shout.lng]).where("notification_radius = 2 AND device_id != :shout_device_id", {shout_device_id: shout.device_id})
	      	# devices += Device.within(NOTIFICATION_RADIUS_3 , :origin => [shout.lat, shout.lng]).where("(notification_radius = -1 OR notification_radius = 3) AND device_id != :shout_device_id", {shout_device_id: shout.device_id})
	    end

	  	push_tokens = devices.map { |device| device.push_token }
	  	begin
	  	  	Urbanairship.push({apids: push_tokens, android: {alert: '"' + shout.description + '"', extra: {shout: shout.to_json}}})
	  	rescue Exception => e
	  	end
	end	
end	