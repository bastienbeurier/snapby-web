class CreateShoutActivitiesAndNotificationsWorker
  include Sidekiq::Worker

  def perform(shout_id)
    shout = Shout.find(shout_id)

    nearby_users = User.select([:id]).within(NOTIFICATION_RADIUS , :origin => [shout.lat, shout.lng]).where("id != :shout_user_id", {shout_user_id: shout.user_id})

    nearby_follower_ids = []

    #create activities for followers, remove followers from nearby users
    unless shout.anonymous
      followers = User.find(shout.user_id).followers
      followers_activities(shout, followers)

      nearby_followers = followers & nearby_users

      nearby_follower_ids = nearby_followers.collect(&:id)

      nearby_users -= nearby_followers
    end

    nearby_activities(shout, nearby_users)

    nearby_user_ids = nearby_users.collect(&:id)

    begin    
      PushNotification.notify_new_shout(shout, nearby_user_ids, nearby_follower_ids)
    rescue Exception => e
      Airbrake.notify(e)
    end
  end

  def nearby_activities(shout, users)
    users.each do |u|
      u.activities.create!(
        subject: shout, 
        activity_type: "nearby_shout", 
        extra: {shout_id: shout.id}
      )
    end
  end

  def followers_activities(shout, followers)
    followers.each do |f|
      f.activities.create!(
        subject: shout, 
        activity_type: "shout_by_followed", 
        extra: {shout_id: shout.id, shouter_username: shout.username}
      )
    end
  end
end