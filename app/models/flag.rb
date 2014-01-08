class Flag < ActiveRecord::Base
  belongs_to :shout

  validates :shout_id, :motive, :flagger_id, presence: true
  # motives = ["abuse", "spam", "privacy", "inaccurate", "other"]
end