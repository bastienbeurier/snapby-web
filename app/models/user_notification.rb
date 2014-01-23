class UserNotification < ActiveRecord::Base
  validates :user_id,      	   presence: true
  validates :sent_count,       presence: true
  validates :last_sent_date,   presence: true
  validates :blocked_count,    presence: true
end
