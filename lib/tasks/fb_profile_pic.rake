namespace :shout_count do
  desc "Save the FB profile picture thumb with paperclip"
  task save_fb_pic: :environment do
  	a = 0
  	User.all.each { |user|
  		if user.facebook_id && user.facebook_username.length < 20
  			user.avatar = open("http://graph.facebook.com/#{user.username}/picture")
      		user.save
      		a += 1
      	end
  	}
  	prop = a / User.all.count
  	Rails.logger.debug "TRUCHOV FB profile picture: #{a} #{prop}"
  end

end
