class TrendingSnapbyNotificationsWorker
  include Sidekiq::Worker

  def perform(snapby_id)
    snapby = Snapby.find(snapby_id)

    User.find(snapby.user_id).activities.create!(
        subject: snapby, 
        activity_type: "my_snapby_trending", 
        extra: {snapby_id: snapby.id}
      )

    users = User.select([:id]).within(NOTIFICATION_RADIUS , :origin => [snapby.lat, snapby.lng]).where("id != :snapby_user_id", {snapby_user_id: snapby.user_id})

    follower_ids = []

    #create activities for followers, remove followers from nearby users
    unless snapby.anonymous
      followers = User.find(snapby.user_id).followers
      followers_activities(snapby, followers)

      follower_ids = followers.collect(&:id)

      users -= followers
    end

    nearby_activities(snapby, users)

    user_ids = users.collect(&:id)

    begin    
      PushNotification.notify_trending_snapby(snapby, user_ids, follower_ids)
    rescue Exception => e
      Airbrake.notify(e)
    end
  end

  def nearby_activities(snapby, users)
    users.each do |u|
      u.activities.create!(
        subject: snapby, 
        activity_type: "nearby_snapby_trending", 
        extra: {snapby_id: snapby.id}
      )
    end
  end

  def followers_activities(snapby, followers)
    followers.each do |f|
      f.activities.create!(
        subject: snapby, 
        activity_type: "snapby_by_followed_trending", 
        extra: {snapby_id: snapby.id, snapbyer_username: snapby.username}
      )
    end
  end
end