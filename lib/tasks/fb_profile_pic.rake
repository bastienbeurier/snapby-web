namespace :fb_profile_pic do
  desc "Save the FB profile picture thumb with paperclip"
  task save_fb_pic: :environment do
  	User.all.each { |user|
  		if user.facebook_id
  			begin
  				user.avatar = open("http://graph.facebook.com/#{user.facebook_id}/picture")
  			rescue Exception => e
  				next
  			end
      		user.save
      	end
  	}
  end

end
