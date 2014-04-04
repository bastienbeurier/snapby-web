class CreateLikeActivityAndNotificationWorker
  include Sidekiq::Worker

  def perform(like_id)
    like = Like.find(like_id)

    nb_likes = like.shout.likes.count

    if like.liker_id != like.shout.user_id and ( nb_likes == 1 or nb_likes % 5 == 0 )
      like.shout.user.activities.create!(
        subject: like.shout,
        activity_type: "my_shout_liked",
        extra: {shout_id: like.shout_id, like_count: nb_likes, liker_username: like.liker_username}
      )

      PushNotification.notify_new_like(like, nb_likes) 
    end
  end
end