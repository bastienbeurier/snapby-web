class UpdateUserScoreWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)

    snapbies = user.snapbies

    snapbies.each do |snapby|
      snapby.update_attributes(user_score: user.liked_snapbies)
    end  
  end
end