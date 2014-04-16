class UserMailer < ActionMailer::Base

  default from: SENDER_EMAIL

  def flagged_snapby_email(flag,snapby)
    @flag=flag
    @snapby=snapby
    mail(to: FLAG_EMAIL, subject: 'A snapby has just been flagged!')
  end

   def welcome_email(user)
    @user=user
    mail(to: @user.email, subject: 'Welcome to the Snapby Community!')
  end
end
