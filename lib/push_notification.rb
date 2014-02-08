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
    user_ids = []

    if comment.shouter_id != comment.commenter_id
      user_ids += [comment.shouter_id]
    end

    shout = comment.shout
    shout.comments.each do |com|
      if ! user_ids.include?(com.commenter_id) and com.commenter_id != comment.commenter_id
        user_ids += [com.commenter_id]
      end
    end

    shout.likes.each do |like|
      if ! user_ids.include?(like.liker_id) and like.liker_id != comment.commenter_id
        user_ids += [like.liker_id]
      end
    end

    users = User.select([:id, :push_token, :os_type]).where(id: user_ids)
    
    if users == nil
      return 
    end

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
      Urbanairship.push({apids: android_tokens, android: {alert: '"' + comment.commenter_username + ' just commented on ' + shout.username + '\'s shout"', extra: {shout: shout.to_json}}})
      Urbanairship.push({device_tokens: ios_tokens, aps: {alert: '"' + comment.commenter_username + ' just commented on ' + shout.username + '\'s shout"', badge: 0}, extra: {shout_id: comment.shout_id}})
    rescue Exception => e
    end
  end

  def self.notify_new_like(like)
    nb_likes = like.shout.likes.count
    if like.liker_id != like.shout.shouter_id and ( nb_likes == 1 or nb_likes % 5 == 0 )
      shouter = User.select([:id, :push_token, :os_type]).where(id: like.shout.user_id)
      if shouter.os_type and shouter.os_type == "android" and shouter.push_token 
        android_tokens += [shouter.push_token]
      elsif shouter.os_type and shouter.os_type == "ios" and shouter.push_token 
        ios_tokens += [shouter.push_token]
      end

      message = '"' + like.liker_username + (nb_likes == 1? ' likes' : ' and ' + (nb_likes - 1) + ' others like') + ' your shout"'
      begin
        Urbanairship.push({apids: android_tokens, android: {alert: message, extra: {like: like.to_json}}})
        Urbanairship.push({device_tokens: ios_tokens, aps: {alert: message, badge: 0}, extra: {like_id: like.id}})
      rescue Exception => e
      end
    end
  end  
end 