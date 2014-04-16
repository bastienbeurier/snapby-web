class CreateSnapbyActivitiesAndNotificationsWorker
  include Sidekiq::Worker

  def perform(snapby_id)
    snapby = Snapby.find(snapby_id)

    nearby_users = User.select([:id]).within(NOTIFICATION_RADIUS , :origin => [snapby.lat, snapby.lng]).where("id != :snapby_user_id", {snapby_user_id: snapby.user_id})

    nearby_follower_ids = []

    #create activities for followers, remove followers from nearby users
    unless snapby.anonymous
      followers = User.find(snapby.user_id).followers
      followers_activities(snapby, followers)

      nearby_followers = followers & nearby_users

      nearby_follower_ids = nearby_followers.collect(&:id)

      nearby_users -= nearby_followers
    end

    nearby_activities(snapby, nearby_users)

    nearby_user_ids = nearby_users.collect(&:id)

    begin    
      PushNotification.notify_new_snapby(snapby, nearby_user_ids, nearby_follower_ids)
    rescue Exception => e
      Airbrake.notify(e)
    end
  end

  def nearby_activities(snapby, users)
    users.each do |u|
      u.activities.create!(
        subject: snapby, 
        activity_type: "nearby_snapby", 
        extra: {snapby_id: snapby.id}
      )
    end
  end

  def followers_activities(snapby, followers)
    followers.each do |f|
      f.activities.create!(
        subject: snapby, 
        activity_type: "snapby_by_followed", 
        extra: {snapby_id: snapby.id, snapbyer_username: snapby.username}
      )
    end
  end
end