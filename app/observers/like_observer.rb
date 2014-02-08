class LikeObserver < ActiveRecord::Observer
  include PushNotification
  def after_create(like)
    PushNotification.notify_new_like(like) 
  end
end