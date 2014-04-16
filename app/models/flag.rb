class Flag < ActiveRecord::Base
  belongs_to :snapby

  validates :snapby_id, :motive, :flagger_id, presence: true
end