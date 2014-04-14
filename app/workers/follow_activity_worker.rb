class FollowActivityWorker
  include Sidekiq::Worker

  def perform(follower_id, followed_id)
    follower = User.find(follower_id)
    followed = User.find(followed_id)

    followed.activities.create!(
      subject: follower, 
      activity_type: "new_follower", 
      extra: {user_id: follower.id, username: follower.username}
    )

    begin    
      PushNotification.notify_new_follower(follower, followed_id)
    rescue Exception => e
      Airbrake.notify(e)
    end
  end
end