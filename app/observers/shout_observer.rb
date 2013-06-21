class ShoutObserver < ActiveRecord::Observer
  # include PushNotification

  def after_create(shout)
    devices = Device.within(10, :origin => [shout.lat, shout.lng]).where("notification_radius != 0")

	push_tokens = devices.map { |device| device.push_token }

	begin
	  	Urbanairship.push({apids: push_tokens, android: {alert: shout.description}})
	rescue Exception => e
	end
  end
end