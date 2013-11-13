class BlackListedDevice < ActiveRecord::Base
  attr_accessible :device_id

  validates :device_id, presence: true
end
