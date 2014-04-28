class User < ActiveRecord::Base
  has_many :snapbies
  has_many :likes, foreign_key: 'liker_id'
  has_many :comments, foreign_key: 'commenter_id'
  has_one :user_notification, dependent: :destroy

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

  #Interpolation for snapby and user collides because attachment has the same name :avatar
  Paperclip.interpolates :file_name do |attachment, style|
    if attachment.instance.class.to_s == "Snapby"
      "image_#{attachment.instance.id.to_s}"
    else 
      "profile_" + attachment.instance.id.to_s
    end
  end

  # This method associates the attribute ":avatar" with a file attachment
  has_attached_file :avatar, styles: { thumb: '100x100#' }, path: ":style/:file_name", bucket: proc { |attachment| Rails.env.development? ? PROFILE_PICTURE_BUCKET_DEV : PROFILE_PICTURE_BUCKET_PROD}
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def response_user
    { id: self.id,
      email: self.email,
      username: self.username,
      black_listed: self.black_listed,
      lat: self.lat,
      lng: self.lng,
      snapby_count: self.snapby_count,
      liked_snapbies: self.liked_snapbies}
  end

  def self.response_users(users)
    users.map { |user| user.response_user }
  end
end
