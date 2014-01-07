class UserMailer < ActionMailer::Base

  # def welcome_email(user)
  #   @user = user
  #   @url  = 'http://example.com/login'
  #   mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  # end

  def flagged_shout_email(flagged_shout)
    @flagged_shout=flagged_shout
    mail(to: "info@street-shout.com", subject: 'A shout has just been flagged!')
  end

  # def password_reset(user)
  #   @user = user
  #   mail :to => user.email, :subject => "Password Reset"
  # end
end
