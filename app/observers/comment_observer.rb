class CommentObserver < ActiveRecord::Observer
  include PushNotification
  def after_create(comment)
    PushNotification.notify_new_comment(comment) 
  end
end