namespace :snapby_count do
  desc "Compute the number of non anonymous snapby posted by user"
  task compute_historical_snapby_count: :environment do
  	User.all.each { |user|
      nbSnapbys = user.snapbys.where(anonymous: false).count
  		user.update_attributes(snapby_count: nbSnapbys)
  	}
  end

end
