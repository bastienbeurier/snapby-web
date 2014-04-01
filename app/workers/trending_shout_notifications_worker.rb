class TrendingShoutNotificationsWorker
  include Sidekiq::Worker

  def perform(shout_id)
    shout = Shout.find(shout_id)

    begin    
      PushNotification.notify_trending_shout(shout)
    rescue Exception => e
      Airbrake.notify(e)
    end
  end
end