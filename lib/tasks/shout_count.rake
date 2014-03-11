namespace :shout_count do
  desc "Compute the number of non anonymous shout posted by user"
  task compute_historical_shout_count: :environment do
  	User.all.each { |user|
      nbShouts = user.shouts.where(anonymous: false).count
  		user.update_attributes(shout_count: nbShouts)
  	}
  end

end
