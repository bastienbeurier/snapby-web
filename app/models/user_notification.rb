class UserNotification < ActiveRecord::Base
  belongs_to :user

  validates_uniqueness_of :user_id
  validates :user_id,      	   presence: true
  validates :sent_count,       presence: true
  validates :last_sent_date,   presence: true
  validates :blocked_count,    presence: true
end
