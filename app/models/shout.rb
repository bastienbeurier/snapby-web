class Shout < ActiveRecord::Base
  has_many :flags
  has_many :comments
  has_many :likes
  belongs_to :user
  
  acts_as_mappable  :default_units => :kms, 
                    :default_formula => :sphere, 
                    :distance_field_name => :distance,
                    :lat_column_name => :lat,
                    :lng_column_name => :lng

  validates :description, presence: true, length: { maximum: 140 }
  validates :lat,         presence: true
  validates :lng,         presence: true
  validates :source,      presence: true
  validates :user_id,     presence: true
  validates :username,    presence: true
  #add validates image
end
