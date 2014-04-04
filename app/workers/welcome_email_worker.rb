class WelcomeEmailWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)

    begin
      UserMailer.welcome_email(user).deliver
    rescue Exception => e
      Airbrake.notify(e)
    end
  end
end