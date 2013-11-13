class RemovedShout < ActiveRecord::Base
  attr_accessible   :shout_id, :removed_by, :shout_created_at, :description, :lat, :lng, :source, :created_at, :display_name, :device_id, :image

  validates :description,      presence: true, length: { maximum: 140 }
  validates :lat,              presence: true
  validates :lng,              presence: true
  validates :source,           presence: true
  validates :display_name,     presence: true
  validates :shout_id,         presence: true
  validates :removed_by,  	   presence: true
  validates :shout_created_at, presence: true
end
