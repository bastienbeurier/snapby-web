class CreateLikeActivityAndNotificationWorker
  include Sidekiq::Worker

  def perform(like_id)
    like = Like.find(like_id)

    nb_likes = like.snapby.likes.count

    if like.liker_id != like.snapby.user_id and ( nb_likes == 1 or nb_likes % 5 == 0 )
      like.snapby.user.activities.create!(
        subject: like.snapby,
        activity_type: "my_snapby_liked",
        extra: {snapby_id: like.snapby_id, like_count: nb_likes, liker_username: like.liker_username}
      )

      PushNotification.notify_new_like(like, nb_likes) 
    end
  end
end