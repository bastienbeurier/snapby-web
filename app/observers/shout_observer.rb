class ShoutObserver < ActiveRecord::Observer
  include PushNotification
  def after_create(shout)
    begin    
      PushNotification.notify_new_shout(shout)
    rescue Exception => e
      Airbrake.notify(e)
    end
  end
end