class LikeObserver < ActiveRecord::Observer
  include PushNotification
  def after_create(like)
    nb_likes = like.shout.likes.count

    if like.liker_id != like.shout.user_id and ( nb_likes == 1 or nb_likes % 5 == 0 )
      like.shout.user_id.activities.create!(
        subject: like.shout,
        activity_type: "my_shout_liked",
        object_id: like.shout_id
      )

      PushNotification.notify_new_like(like, nb_likes) 
    end
  end
end