module DevelopmentTasks
	def self.demo
		shouts = [["Great preacher in front of the 24th Street Mission Bar Station!", "Harold", 56.minutes, 37.752199, -122.418584, "street-shout1/bastien--1375319297966"],
	        ["A couple is getting married in the middle of the Dolores Park...", "Anyone", 45.minutes, 37.758942, -122.426620, nil],
	        ["There is an accident on the highway, it's totally blocked...", "Altruist person", 37.minutes, 37.771597, -122.406321, "street-shout1/bastien--1375319375888"],
	        ["Happy hour at the Mad Dog In The Fog, half price on all drinsk until 7!", "Mad Dog In The Fog", 33.minutes, 37.772072, -122.431018, "street-shout1/bastien--1375319235465"],
	        ["A bunch of scary dudes at the Haight St entrance of the Golen Gate Park", "Sarah", 29.minutes, 37.769069, -122.453785, nil],
	        ["Sales start early at the Scotch & Soda store on Fillmore Street!!!", "Scoth & Soda", 23.minutes, 37.788348, -122.433824, "street-shout1/bastien--1375319357749"],
	        ["Selling half price tickets for tonight's concert at the entrance of the Davies Symphony Hall", "Seller", 21.minutes, 37.777601, -122.420257, "street-shout1/bastien--1375319339113"],
	        ["Charlie Chaplin retrospective starting tonight at the independent cinema Clay Landmark Theatre", "Landmark Theatre", 15.minutes, 37.790320, -122.434559, "street-shout1/bastien--1375319197325"],
	        ["Just saw Mark Zuckerberg coming out of the taqueria El Farolito", "Tech fanboy", 41.minutes, 37.756058, -122.416633, "street-shout1/bastien--1375319280873"],
	        ["Farmer's market at the Ferry Buidling, closing in an hout!!", "Farmer's Marker", 6.minutes, 37.794779, -122.393253, "street-shout1/bastien--1375319392766"],
	        ["The SF MOMA is packed and the exhibition is not that great, not worth it", "Art is my life", 3.minutes, 37.785707, -122.401128, nil],
	        ["3 police cars misteriously gathered at that corner, what is going on?", "Curious man", 46.minutes, 37.781315, -122.418852, "street-shout1/bastien--1375319261102"],
	        ["I don't really know but I just saw my neighbor getting arrested", "Curious too", 2.minutes, 37.781061, -122.419066, "street-shout1/bastien--1375319218344"],
	        ["Helena Miriada is doing her first painting exhibition in the Creativity Explored art gallery, it's open to all!", "Helena Miriada", 11.minutes, 37.778025, -122.405140, nil],
	        ["Green Peace volunteers on Marker Street available to give you information and goodies!", "Green Peace", 17.minutes, 37.788556, -122.402287, nil],
	        ["Awesome live music at the Revolution Cafe, bring pianists, guitarists, drumers if they want to participate!", "Music lover", 39.minutes, 37.755159, -122.424163, "street-shout1/bastien--1375319317071"],
	        ["Any girl in the Castro area? I can only see dudes in the QBar tonight!", "Jerk", 19.minutes, 37.761521, -122.435224, nil],
	        ["Come try some instruments at Guitar Center and checkout our crazy sales on keyboards", "Guitar Center", 12.minutes, 37.790803, -122.422736, nil],
	        ["The Marker street drumer is back and ready to play for you for at least an hour!", "Marker Street drumer", 6.minutes, 37.785148, -122.406739, "street-shout1/bastien--1375319163701"],
	        ["We are playing soccer and missing a player, anyone near?", "Soccer player", 9.minutes, 37.750663, -122.412286, nil],
	        ["To windy today to play tennis at Dolores :(", "Frustrated tennis player", 52.minutes, 37.761114, -122.426727, nil]]

		shouts.each do |content|
			shout_creation_time = Time.now - content[2]
			shout = Shout.new(lat: content[3], lng: content[4], display_name: content[1], description: content[0], image: content[5], source: "native", created_at: shout_creation_time)
			shout.save
		end	
	end
end