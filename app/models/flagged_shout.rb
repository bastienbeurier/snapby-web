class FlaggedShout < ActiveRecord::Base
  attr_accessible   :shout_id, :count, :motive, :device_id

  validates :shout_id,  presence: true
  validates :count,     presence: true
  validates :motive,    presence: true
  validates :device_id, presence: true
end
