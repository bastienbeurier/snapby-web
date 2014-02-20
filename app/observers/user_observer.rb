class UserObserver < ActiveRecord::Observer

  def after_create(user)
  	begin
    	UserMailer.welcome_email(user).deliver
  	rescue Exception => e
    	Airbrake.notify(e)
  	end
  end
end