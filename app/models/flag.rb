class Flag < ActiveRecord::Base
  belongs_to :snapby

  validates :snapby_id, :motive, :flagger_id, presence: true
  # motives = ["abuse", "spam", "privacy", "inaccurate", "other"]
end