module PushNotification
    def self.notify_new_shout(shout)
        devices = []

        if Rails.env.development?
            devices = Device.select([:push_token, :os_type]).all
            # devices = Device.within(NOTIFICATION_RADIUS_1 , :origin => [shout.lat, shout.lng]).where("notification_radius = 1")
            # devices += Device.within(NOTIFICATION_RADIUS_2 , :origin => [shout.lat, shout.lng]).where("notification_radius = 2")
            # devices += Device.within(NOTIFICATION_RADIUS_3 , :origin => [shout.lat, shout.lng]).where("notification_radius = -1 OR notification_radius = 3")
        else
            devices = Device.select([:push_token, :os_type]).where("device_id != :shout_device_id", {shout_device_id: shout.device_id})
            # devices = Device.within(NOTIFICATION_RADIUS_1 , :origin => [shout.lat, shout.lng]).where("notification_radius = 1 AND device_id != :shout_device_id", {shout_device_id: shout.device_id})
            # devices += Device.within(NOTIFICATION_RADIUS_2 , :origin => [shout.lat, shout.lng]).where("notification_radius = 2 AND device_id != :shout_device_id", {shout_device_id: shout.device_id})
            # devices += Device.within(NOTIFICATION_RADIUS_3 , :origin => [shout.lat, shout.lng]).where("(notification_radius = -1 OR notification_radius = 3) AND device_id != :shout_device_id", {shout_device_id: shout.device_id})
        end

        android_tokens = []
        ios_tokens = []

        devices.each do |device|
            if device.os_type == "android"
                android_tokens += [device.push_token]
                Rails.logger.debug "BAB ANDROID TOKEN: #{device.push_token}"
            elsif device.os_type == "ios"
                ios_tokens += [device.push_token]
                Rails.logger.debug "BAB IOS TOKEN: #{device.push_token}"
            end
        end

        begin
            Urbanairship.push({apids: android_tokens, android: {alert: '"' + shout.description + '"', extra: {shout: shout.to_json}}})
            Urbanairship.push({device_tokens: ios_tokens, aps: {alert: '"' + shout.description + '"', badge: 0}})
        rescue Exception => e
        end
    end 
end 