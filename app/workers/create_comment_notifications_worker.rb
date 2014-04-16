class CreateCommentNotificationsWorker
  include Sidekiq::Worker

  def perform(comment_id)
    comment = Comment.find(comment_id)

    notified_user_ids_for_comment = []
    notified_user_ids_for_like = []

    snapby = comment.snapby

    #Activity for previous commenters if they are not the current commenter
    snapby.comments.each do |com|
      if !notified_user_ids_for_comment.include?(com.commenter_id) and com.commenter_id != comment.commenter_id and com.commenter_id != comment.snapbyer_id
        notified_user_ids_for_comment += [com.commenter_id]
      end
    end

    #Activity for previous likers if not already sent notification for comment and if not the current commenter
    snapby.likes.each do |like|
      if !notified_user_ids_for_comment.include?(like.liker_id) and like.liker_id != comment.commenter_id and like.liker_id != comment.snapbyer_id
        notified_user_ids_for_like += [like.liker_id]
      end
    end

    begin    
      PushNotification.notify_new_comment(comment, notified_user_ids_for_comment, notified_user_ids_for_like)
    rescue Exception => e
      Airbrake.notify(e)
    end
  end
end