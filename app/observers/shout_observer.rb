class ShoutObserver < ActiveRecord::Observer
  include PushNotification

  def after_create(shout)
    PushNotification.new_shout(shout)
  end
end