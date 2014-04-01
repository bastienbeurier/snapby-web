module PushNotification
  def self.notify_new_shout(shout, user_ids, follower_ids)
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

    message = 'New shout in your area'
    follower_message = 'New shout by @' + shout.username

    android_extra = {shout: shout.to_json, new_shout: true}
    ios_extra = {shout_id: shout.id, new_shout: true}

    send_notifications(notified_user_ids, message, android_extra, ios_extra)

    unless shout.anonymous
      send_notifications(follower_ids, follower_message, android_extra, ios_extra)
    end
  end

  def self.notify_trending_shout(shout)
    users = []
    notified_user_ids = []
    
    users = User.select([:id]).within(TRENDING_NOTIFICATION_RADIUS , :origin => [shout.lat, shout.lng]).where("id != :shout_user_id", {shout_user_id: shout.user_id})
    user_ids = users.collect(&:id)

    message = 'A shout is trending in your area!'
    shouter_message = 'Your shout is trending!'

    android_extra = {shout: shout.to_json, trending: true}
    ios_extra = {shout_id: shout.id, trending: true}

    send_notifications(user_ids, message, android_extra, ios_extra)
    send_notifications([shout.user_id], shouter_message, android_extra, ios_extra)
  end

  def self.notify_new_comment(comment)
    notified_user_ids_for_comment = []
    notified_user_ids_for_like = []

    shout = comment.shout

    #Send notification to previous commenters if they are not the current commenter
    shout.comments.each do |com|
      if !notified_user_ids_for_comment.include?(com.commenter_id) and com.commenter_id != comment.commenter_id and com.commenter_id != comment.shouter_id
        notified_user_ids_for_comment += [com.commenter_id]
      end
    end

    #Send notification to previous likers if not already sent notification for comment and if not the current commenter
    shout.likes.each do |like|
      if !notified_user_ids_for_comment.include?(like.liker_id) and like.liker_id != comment.commenter_id and like.liker_id != comment.shouter_id
        notified_user_ids_for_like += [like.liker_id]
      end
    end

    message_commenters = 'New comment from ' + comment.commenter_username + ' on the shout you commented'
    message_likers = 'New comment from ' + comment.commenter_username + ' on the shout you liked'  
    android_extra = {shout: shout.to_json, new_comment: true}
    ios_extra = {shout_id: comment.shout_id, new_comment: true}

    send_notifications(notified_user_ids_for_comment, message_commenters, android_extra, ios_extra)
    send_notifications(notified_user_ids_for_like, message_likers, android_extra, ios_extra)

    #Send notification to shouter if he is not the current commenter
    if (comment.shouter_id != comment.commenter_id)
      message_shouter = 'New comment from ' + comment.commenter_username + ' on your shout'
      send_notifications([comment.shouter_id], message_shouter, android_extra, ios_extra)
    end
  end

  def self.notify_new_like(like, nb_likes)
    message = like.liker_username + (nb_likes == 1? ' likes' : ' and ' + (nb_likes - 1).to_s + ' others like') + ' your shout'
    android_extra = {shout: like.shout.to_json, new_like: true}
    ios_extra = {shout_id: like.shout_id, new_like: true}

    send_notifications([like.shout.user_id], message, android_extra, ios_extra)
  end 

  def self.notify_new_facebook_friend(user, friend_ids, android_extra, ios_extra)
    message = user.facebook_name + ' joined Shout as @' + user.username 
    android_extra = {user_id: user.id, new_friend: true}
    ios_extra = {user_id: user.id, new_friend: true}
    send_notifications(friend_ids, message, nil, nil)
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
    end
  end 
end 