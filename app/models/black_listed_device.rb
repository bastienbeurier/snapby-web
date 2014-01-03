class BlackListedDevice < ActiveRecord::Base
  validates :device_id, presence: true
end
