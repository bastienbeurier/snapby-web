class Comment < ActiveRecord::Base
	belongs_to :shout

	validates :shout_id, :shouter_id, :commenter_id, :commenter_username, :description, presence: true
end
