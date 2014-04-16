class Like < ActiveRecord::Base
	belongs_to :snapby
	belongs_to :liker, class_name: 'User'

	validates :snapby_id, :liker_id, :liker_username, presence: true
end
