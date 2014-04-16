class CreateLikeActivityAndNotificationWorker
  include Sidekiq::Worker

  def perform(like_id)
    like = Like.find(like_id)

    nb_likes = like.snapby.likes.count

    if like.liker_id != like.snapby.user_id and ( nb_likes == 1 or nb_likes % 5 == 0 )
      PushNotification.notify_new_like(like, nb_likes) 
    end
  end
end