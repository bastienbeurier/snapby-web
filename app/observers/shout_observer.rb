class ShoutObserver < ActiveRecord::Observer
  # Find a way to include module and move code to this module
  # include PushNotification

  def after_create(shout)
    devices = Device.within(10, :origin => [shout.lat, shout.lng]).where("notification_radius IS NULL OR notification_radius > 0")

	push_tokens = devices.map { |device| device.push_token }

	begin
	  	Urbanairship.push({apids: push_tokens, android: {alert: '"' + shout.description + '"'}})
	rescue Exception => e
	end
  end
end