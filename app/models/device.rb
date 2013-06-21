class Device < ActiveRecord::Base
  acts_as_mappable  :default_units => :kms, 
                    :default_formula => :sphere, 
                    :distance_field_name => :distance,
                    :lat_column_name => :lat,
                    :lng_column_name => :lng

  attr_accessible :api_version, :app_version, :device_id, :device_model, :lat, :lng, :notification_radius, :os_type, :os_version, :push_token

  validates_uniqueness_of :device_id
end
