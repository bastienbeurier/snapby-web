class User < ActiveRecord::Base
  acts_as_mappable  :default_units => :kms, 
                    :default_formula => :sphere, 
                    :distance_field_name => :distance,
                    :lat_column_name => :lat,
                    :lng_column_name => :lng

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :token_authenticatable, :validatable

  #devise automatically checks email format and convert to lower case
  validates_uniqueness_of :email, :username
  validates :email, presence: true
  validates :password, presence: true #between 6..128 chars (defined in Devise config)
  validates :username, presence: true, length: { minimum: 6, maximum: 20 }
end
