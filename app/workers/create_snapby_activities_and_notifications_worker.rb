class CreateSnapbyActivitiesAndNotificationsWorker
  include Sidekiq::Worker

  def perform(snapby_id)
    snapby = Snapby.find(snapby_id)

    nearby_users = User.select([:id]).within(NOTIFICATION_RADIUS , :origin => [snapby.lat, snapby.lng]).where("id != :snapby_user_id", {snapby_user_id: snapby.user_id})

    nearby_follower_ids = []

    #create activities for followers, remove followers from nearby users
    unless snapby.anonymous
      followers = User.find(snapby.user_id).followers

      nearby_followers = followers & nearby_users

      nearby_follower_ids = nearby_followers.collect(&:id)

      nearby_users -= nearby_followers
    end

    nearby_user_ids = nearby_users.collect(&:id)

    begin    
      PushNotification.notify_new_snapby(snapby, nearby_user_ids, nearby_follower_ids)
    rescue Exception => e
      Airbrake.notify(e)
    end
  end
end