class FlaggedShout < ActiveRecord::Base
  validates :shout_id,  presence: true
  validates :motive,    presence: true
  #add validates :user_ids, presence: true
end
