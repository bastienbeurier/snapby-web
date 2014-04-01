class AutofollowWorker
  include Sidekiq::Worker

  def perform(friend_ids, current_user_id)
    #Android sends a String that we have to parse
    if friend_ids.is_a? String
      friend_ids = friend_ids[1..-2].split(", ")
    end

    facebook_friends = User.where(facebook_id: friend_ids)

    current_user = User.find(current_user_id)

    facebook_friends.each { |user|
      current_user.mutual_follow!(user)
    }

    begin    
      PushNotification.notify_new_facebook_friend(current_user, facebook_friends.collect(&:id))
    rescue Exception => e
      Airbrake.notify(e)
    end
  end
end