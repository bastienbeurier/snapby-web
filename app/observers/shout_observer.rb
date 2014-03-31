class ShoutObserver < ActiveRecord::Observer
  include PushNotification
  def after_create(shout)
    CreateShoutNotificationsWorker.perform_async(shout.id)
  end
end