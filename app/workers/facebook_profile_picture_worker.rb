class FacebookProfilePictureWorker
  include Sidekiq::Worker
  include ApplicationHelper

  def perform(user_id)
    user = User.find(user_id)

    user.avatar = open(URI.parse(process_uri("http://graph.facebook.com/#{user.facebook_id}/picture")))

    user.save
  end
end