class FlaggedShout < ActiveRecord::Base
  validates :shout_id,  presence: true
  validates :motive,    presence: true
  validates :device_id, presence: true
end
