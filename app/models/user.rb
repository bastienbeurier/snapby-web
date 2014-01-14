class User < ActiveRecord::Base
  acts_as_mappable  :default_units => :kms, 
                    :default_formula => :sphere, 
                    :distance_field_name => :distance,
                    :lat_column_name => :lat,
                    :lng_column_name => :lng

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :token_authenticatable, :validatable

  #devise automatically checks email format and convert to lower case
  #devise validates uniqueness of email
  validates_uniqueness_of :username, case_sensitive: false
  validates :email, presence: true
  validates :password, presence: true , on: :create #between 6..128 chars (defined in Devise config)
  validates :username, presence: true, length: { minimum: MIN_USERNAME_LENGTH, maximum: MAX_USERNAME_LENGTH }

  def save_and_return_token
    if save
      ensure_authentication_token!
      render json: { result: { user: self, auth_token: authentication_token } }, status: 201
    else
      render json: { errors: { user: errors } }, status: 222 # Need a success code to handle errors in IOS
    end
  end
end
