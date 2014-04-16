class CreateCommentActivitiesAndNotificationsWorker
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

    commenters_activities(comment, notified_user_ids_for_comment)

    #Activity for previous likers if not already sent notification for comment and if not the current commenter
    snapby.likes.each do |like|
      if !notified_user_ids_for_comment.include?(like.liker_id) and like.liker_id != comment.commenter_id and like.liker_id != comment.snapbyer_id
        notified_user_ids_for_like += [like.liker_id]
      end
    end

    likers_activities(comment, notified_user_ids_for_like)

    #Activity for snapbyer if he is not the current commenter
    if (comment.snapbyer_id != comment.commenter_id)
      User.find(comment.snapbyer_id).activities.create!(
        subject: comment.snapby, 
        activity_type: "my_snapby_commented", 
        extra: {snapby_id: comment.snapby.id, commenter_username: comment.commenter_username}
      )
    end

    begin    
      PushNotification.notify_new_comment(comment, notified_user_ids_for_comment, notified_user_ids_for_like)
    rescue Exception => e
      Airbrake.notify(e)
    end
  end

  def commenters_activities(comment, commenter_ids)
    commenter_ids.each do |id|
      User.find(id).activities.create!(
        subject: comment.snapby, 
        activity_type: "commenter_snapby_commented", 
        extra: {snapby_id: comment.snapby.id, commenter_username: comment.commenter_username}
      )
    end
  end

  def likers_activities(comment, liker_ids)
    liker_ids.each do |id|
      User.find(id).activities.create!(
        subject: comment.snapby, 
        activity_type: "liker_snapby_commented", 
        extra: {snapby_id: comment.snapby.id, commenter_username: comment.commenter_username}
      )
    end
  end
end