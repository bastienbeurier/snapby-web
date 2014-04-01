class CreateCommentActivitiesAndNotificationsWorker
  include Sidekiq::Worker

  def perform(comment_id)
    comment = Comment.find(comment_id)

    notified_user_ids_for_comment = []
    notified_user_ids_for_like = []

    shout = comment.shout

    #Activity for previous commenters if they are not the current commenter
    shout.comments.each do |com|
      if !notified_user_ids_for_comment.include?(com.commenter_id) and com.commenter_id != comment.commenter_id and com.commenter_id != comment.shouter_id
        notified_user_ids_for_comment += [com.commenter_id]
      end
    end

    commenters_activities(comment, notified_user_ids_for_comment)

    #Activity for previous likers if not already sent notification for comment and if not the current commenter
    shout.likes.each do |like|
      if !notified_user_ids_for_comment.include?(like.liker_id) and like.liker_id != comment.commenter_id and like.liker_id != comment.shouter_id
        notified_user_ids_for_like += [like.liker_id]
      end
    end

    likers_activities(comment, notified_user_ids_for_like)

    #Activity for shouter if he is not the current commenter
    if (comment.shouter_id != comment.commenter_id)
      User.find(comment.shouter_id).activities.create!(
        subject: comment.shout, 
        activity_type: "my_shout_commented", 
        object_id: comment.shout.id
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
        subject: comment.shout, 
        activity_type: "commenter_shout_commented", 
        object_id: comment.shout.id
      )
    end
  end

  def likers_activities(comment, liker_ids)
    liker_ids.each do |id|
      User.find(id).activities.create!(
        subject: comment.shout, 
        activity_type: "liker_shout_commented", 
        object_id: comment.shout.id
      )
    end
  end
end