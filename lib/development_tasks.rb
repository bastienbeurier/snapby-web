module DevelopmentTasks
	def demo
		shouts = [["Great preacher in front of the 24th Street Mission Bar Station!", "Harold", 56.minutes, 37.752199, -122.418584],
        ["A couple is getting married in the middle of the Dolores Park...", "Anyone", 45.minutes, 37.758942, -122.426620],
        ["There is an accident on the highway, it's totally blocked...", "Altruist person", 37.minutes, 37.771597, -122.406321],
        ["Happy hour at the Mad Dog In The Fog, half price on all drinsk until 7!", "Mad Dog In The Fog", 33.minutes, 37.772072, -122.431018 ],
        ["A bunch of scary dudes at the Haight St entrance of the Dolores Park", "Sarah", 29.minutes, 37.769069, -122.453785],
        ["Sales start early at the Scotch & Soda store on Fillmore Street!!!", "Scoth & Soda", 23.minutes, 37.788348, -122.433824],
        ["Selling half price tickets for tonight's concert at the entrance of the Davies Symphony Hall", "Seller", 21.minutes, 37.777601, -122.420257],
        ["Charlie Chaplin retrospective starting tonight at the independent cinema Clay Landmark Theatre", "Landmark Theatre", 15.minutes, 37.790320, -122.434559],
        ["Just saw Mark Zuckerberg coming out of the taqueria El Farolito", "Tech fanboy", 41.minutes, 37.756058, -122.416633],
        ["Farmer's marker at the Ferry Buidling, closing in an hout!!"], "Farmer's Marker", 6.minutes, 37.794779, -122.393253],
        ["The SF MOMA is packed and the exhibition is not that great, not worth it", "Art is my life", 3.minutes, 37.785707, -122.401128],
        ["3 police cars misteriously gathered at that corner, what is going on?", "Curious man", 46.minutes, 37.781315, -122.418852],
        ["I don't really know but I just saw my neighbor getting arrested", "Curious too", 2.minutes, 37.781061, -122.419066],
        ["Helena Miriada is doing her first painting exhibition in the Creativity Explored art gallery, it's open to all!", "Helena Miriada", 11.minutes, 37.778025, -122.405140],
        ["Green Peace volunteers on Marker Street available to give you information and goodies!", "Green Peace", 17.minutes, 37.788556, -122.402287],
        ["Awesome live music at the Revolution Cafe, bring pianists, guitarists, drumers if they want to participate!", "Music lover", 39.minutes, 37.755159, -122.424163],
        ["Any girl in the Castro area, I can only see dudes in the QBar tonight!", "Hot guy", 19.minutes, 37.761521, -122.435224],
        ["Come try some instruments at Guitar Center and checkout our crazy sales on keyboards", "Guitar center", 12.minutes, 37.790803, -122.422736],
        ["The Marker street drumer is back and ready to play for you for at least an hour!", "Marker Street drumer", 6.minutes, 37.785148, -122.406739],
        ["We are playing soccer and missing a player, anyone near?", "Soccer player", 9.minutes, 37.750663, -122.412286],
        ["To windy today to play tennis at Dolores :(", "Frustrated tennis player", 52.minutes, 37.761114, -122.426727]]

		shouts.each do |content|
			shout_creation_time = Time.now - content[2]
			shout = Shout.new(lat: content[3], lng: content[4], display_name: content[1], description: content[0], source: "native", create_at: shout_creation_time)
			shout.save
		end	
	end
end