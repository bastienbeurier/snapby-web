class ShoutObserver < ActiveRecord::Observer
  include PushNotification
  def after_create(shout)
    PushNotification.notify_new_shout(shout) 
  end
end