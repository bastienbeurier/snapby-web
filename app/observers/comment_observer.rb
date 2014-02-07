class CommentObserver < ActiveRecord::Observer
  include PushNotification
  def after_create(comment)
  	Rails.logger.debug "observer"
    PushNotification.notify_new_comment(comment) 
  end
end