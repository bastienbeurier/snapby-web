class ShoutObserver < ActiveRecord::Observer
  def after_create(shout)
    PushNotification.new_shout(shout)
  end
end