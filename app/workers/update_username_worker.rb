class UpdateUsernameWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)

    snapbies = user.snapbies

    snapbies.each do |snapby|
      snapby.update_attributes(username: user.username)
    end  

    comments = user.comments

    comments.each do |comment|
      comment.update_attributes(commenter_username: user.username)
    end
  end
end