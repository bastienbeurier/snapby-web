class UserMailer < ActionMailer::Base

  default from: SENDER_EMAIL

  def flagged_shout_email(flag,shout)
    @flag=flag
    @shout=shout
    mail(to: FLAG_EMAIL, subject: 'A shout has just been flagged!')
  end

   def welcome_email(user)
    @user=user
    mail(to: @user.email, subject: 'Welcome!')
  end
end
