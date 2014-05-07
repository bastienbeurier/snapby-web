class CreateSnapbyActivitiesAndNotificationsWorker
  include Sidekiq::Worker

  def perform(snapby_id)
    snapby = Snapby.find(snapby_id)

    if Rails.env.development?
      nearby_users = User.select([:id]).within(NOTIFICATION_RADIUS , :origin => [snapby.lat, snapby.lng])
    else
      nearby_users = User.select([:id]).within(NOTIFICATION_RADIUS , :origin => [snapby.lat, snapby.lng]).where("id != :snapby_user_id", {snapby_user_id: snapby.user_id})
    end

    nearby_user_ids = nearby_users.collect(&:id)

    begin    
      PushNotification.notify_new_snapby(snapby, nearby_user_ids)
    rescue Exception => e
      Airbrake.notify(e)
    end
  end
end