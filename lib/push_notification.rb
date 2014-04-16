module PushNotification
  def self.notify_new_snapby(snapby, user_ids, follower_ids)
    notified_user_ids = []

    user_ids.each do |user_id|
      user_notification = UserNotification.find_by_user_id(user_id)

      #Create UserNotification instance if user doesn't have one
      if !user_notification
        old_date = DateTime.new(2000, 1, 1)
        user_notification  = UserNotification.new(user_id: user_id, sent_count: 0, last_sent: old_date, blocked_count: 0)
      end

      #Check if notification delay is over
      if user_notification.last_sent + NOTIFICATION_DELAY < Time.now
        user_notification.blocked_count = 0
        user_notification.sent_count += 1
        user_notification.last_sent = Time.now

        notified_user_ids += [user_id]
      #Otherwise, block de notification
      else
        user_notification.blocked_count += 1
      end 

      user_notification.save!
    end

    message = 'New snapby in your area'

    android_extra = {snapby: snapby.response_snapby.to_json, notif_type: "new_snapby"}
    ios_extra = {snapby_id: snapby.id, notif_type: "new_snapby"}

    send_notifications(notified_user_ids, message, android_extra, ios_extra)
  end

  def self.notify_new_comment(comment, notified_user_ids_for_comment, notified_user_ids_for_like)
    message_commenters = 'New comment from ' + comment.commenter_username + ' on the snapby you commented'
    message_likers = 'New comment from ' + comment.commenter_username + ' on the snapby you liked'  
    android_extra = {snapby: comment.snapby.response_snapby.to_json, notif_type: "new_comment"}
    ios_extra = {snapby_id: comment.snapby_id, notif_type: "new_comment"}

    send_notifications(notified_user_ids_for_comment, message_commenters, android_extra, ios_extra)
    send_notifications(notified_user_ids_for_like, message_likers, android_extra, ios_extra)

    #Send notification to snapbyer if he is not the current commenter
    if (comment.snapbyer_id != comment.commenter_id)
      message_snapbyer = 'New comment from ' + comment.commenter_username + ' on your snapby'
      send_notifications([comment.snapbyer_id], message_snapbyer, android_extra, ios_extra)
    end
  end

  def self.notify_new_like(like, nb_likes)
    message = like.liker_username + (nb_likes == 1? ' likes' : ' and ' + (nb_likes - 1).to_s + ' others like') + ' your snapby'
    android_extra = {snapby: like.snapby.response_snapby.to_json, notif_type: "new_like"}
    ios_extra = {snapby_id: like.snapby_id, notif_type: "new_like"}

    send_notifications([like.snapby.user_id], message, android_extra, ios_extra)
  end 

  def self.send_notifications(user_ids, message, android_extra, ios_extra)
    users = User.select([:push_token, :os_type]).where(id: user_ids)

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
      if android_extra
        Urbanairship.push({apids: android_tokens, android: {alert: message, extra: android_extra}})
      else
        Urbanairship.push({apids: android_tokens, android: {alert: message}})
      end

      if ios_extra
        Urbanairship.push({device_tokens: ios_tokens, aps: {alert: message, badge: 0}, extra: ios_extra})
      else
        Urbanairship.push({device_tokens: ios_tokens, aps: {alert: message, badge: 0}})
      end
    rescue Exception => e
      Airbrake.notify(e)
    end
  end 

  def self.update_users_notifications(user_ids)
    user_ids.each do |user_id|
      user_notification = UserNotification.find_by_user_id(user_id)
      #Create UserNotification instance if user doesn't have one, else update last sent time 
      if !user_notification
        user_notification  = UserNotification.new(user_id: user_id, sent_count: 0, last_sent: Time.now, blocked_count: 0)
      else
        user_notification.last_sent = Time.now
      end
      user_notification.save!
    end
  end
end 