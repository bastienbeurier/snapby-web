module PushNotification
	def self.new_shout(shout)
		#Add condition where device id != shout device id (no notification to sender)
		#Default radius to 10km for now
		devices = Device.within(10, :origin => [shout.lat, shout.lng]).where("notification_radius != 0")

		push_tokens = devices.map { |device| device.push_token }

		Urbanairship.push({apids: push_tokens, android: {alert: shout.description}})
	end	
end