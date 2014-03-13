namespace :shout_count do
  desc "Save the FB profile picture thumb with paperclip"
  task save_fb_pic: :environment do
  	User.all.each { |user|
  		user.avatar = open("http://graph.facebook.com/#{user.username}/picture")
      	user.save
  	}
  end

end
