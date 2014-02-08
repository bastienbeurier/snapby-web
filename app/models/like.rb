class Like < ActiveRecord::Base
	belongs_to :shout
	belongs_to :liker, class_name: 'User'

	validates :shout_id, :liker_id, :liker_username, presence: true
end
