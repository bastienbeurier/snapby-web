class Shout < ActiveRecord::Base
  acts_as_mappable  :default_units => :miles, 
                    :default_formula => :sphere, 
                    :distance_field_name => :distance,
                    :lat_column_name => :lat,
                    :lng_column_name => :lng

  attr_accessible   :description, :lat, :lng

  validates :description, presence: true, length: { maximum: 50 }
  validates :lat,         presence: true
  validates :lng,         presence: true
end
