class TrendingShoutNotificationsWorker
  include Sidekiq::Worker

  def perform(shout_id)
    shout = Shout.find(shout_id)

    users = User.select([:id]).within(NOTIFICATION_RADIUS , :origin => [shout.lat, shout.lng]).where("id != :shout_user_id", {shout_user_id: shout.user_id})

    follower_ids = []

    #create activities for followers, remove followers from nearby users
    unless shout.anonymous
      followers = User.find(shout.user_id).followers
      followers_activities(shout, followers)

      follower_ids = followers.collect(&:id)

      users -= followers
    end

    nearby_activities(shout, users)

    user_ids = users.collect(&:id)

    begin    
      PushNotification.notify_trending_shout(shout, user_ids, follower_ids)
    rescue Exception => e
      Airbrake.notify(e)
    end
  end

  def nearby_activities(shout, users)
    users.each do |u|
      u.activities.create!(
        subject: shout, 
        activity_type: "nearby_shout_trending", 
        extra: {shout_id: shout.id}
      )
    end
  end

  def followers_activities(shout, followers)
    followers.each do |f|
      f.activities.create!(
        subject: shout, 
        activity_type: "shout_by_followed_trending", 
        extra: {shout_id: shout.id, shouter_username: shout.username}
      )
    end
  end
end