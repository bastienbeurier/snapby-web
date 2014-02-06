module PushNotification
  def self.notify_new_shout(shout)
    devices = []
    users = []

    if Rails.env.development?
      devices = Device.select([:push_token, :os_type]).all
      users = User.select([:id, :push_token, :os_type]).all
    else
        # devices = Device.select([:push_token, :os_type]).where("device_id != :shout_device_id", {shout_device_id: shout.device_id})
      devices = Device.select([:push_token, :os_type]).within(NOTIFICATION_RADIUS , :origin => [shout.lat, shout.lng]).where("device_id != :shout_device_id", {shout_device_id: shout.device_id})
      users = User.select([:id, :push_token, :os_type]).within(NOTIFICATION_RADIUS , :origin => [shout.lat, shout.lng]).where("id != :shout_user_id", {shout_user_id: shout.user_id})
    end

    android_tokens = []
    ios_tokens = []

    devices.each do |device|
      if device.os_type == "android"
        android_tokens += [device.push_token]
      elsif device.os_type == "ios"
        ios_tokens += [device.push_token]
      end
    end

    users.each do |user|
      user_notification = user.user_notification

      #Create UserNotification instance if user doesn't have one
      if !user_notification
        old_date = DateTime.new(2000, 1, 1)
        user_notification  = UserNotification.new(user_id: user.id, sent_count: 0, last_sent: old_date, blocked_count: 0)
      end

      #Check if notification delay is over
      if user_notification.last_sent + NOTIFICATION_DELAY < Time.now
        user_notification.blocked_count = 0

        if user.os_type and user.os_type == "android" and user.push_token and !android_tokens.include?(user.push_token)
          android_tokens += [user.push_token]
          user_notification.sent_count += 1
          user_notification.last_sent = Time.now
        elsif user.os_type and user.os_type == "ios" and user.push_token and !ios_tokens.include?(user.push_token)
          ios_tokens += [user.push_token]
          user_notification.sent_count += 1
          user_notification.last_sent = Time.now
        end
      #Otherwise, block de notification
      else
        user_notification.blocked_count += 1
      end 

      user_notification.save!
    end

    begin
        Urbanairship.push({apids: android_tokens, android: {alert: '"' + shout.description + '"', extra: {shout: shout.to_json}}})
        Urbanairship.push({device_tokens: ios_tokens, aps: {alert: '"' + shout.description + '"', badge: 0}, extra: {shout_id: shout.id}})
    rescue Exception => e
    end
  end

  def self.notify_new_comment(comment)
    
    user_ids = [comment.shouter_id]
    shout = comment.shout
    shout.comments.each do |com|
      if ! user_ids.include?(com.shouter_id) and com.shouter_id != comment.shouter_id
        user_ids += [com.shouter_id]
    end
    users = User.select([:id, :push_token, :os_type]).where(id: user_ids)

    android_tokens = []
    ios_tokens = []
    users.each do |user|
      if user.os_type and user.os_type == "android" and user.push_token 
        android_tokens += [user.push_token]
      elsif user.os_type and user.os_type == "ios" and user.push_token 
        ios_tokens += [user.push_token]
      end
    end

    begin
      Urbanairship.push({apids: android_tokens, android: {alert: '"' + comment.commenter_username + ' commented on ' + shout.username + '''s shout"', extra: {shout: comment.to_json}}})
      Urbanairship.push({device_tokens: ios_tokens, aps: {alert: '"' + comment.commenter_username + ' commented on ' + shout.username + '''s shout"', badge: 0}, extra: {shout_id: comment.id}})
    rescue Exception => e
    end
  end 
end 