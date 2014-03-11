class User < ActiveRecord::Base
  has_many :shouts
  has_many :likes, foreign_key: 'liker_id'
  has_one :user_notification

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id", class_name:  "Relationship", dependent: :destroy

  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships

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

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id).present?
  end

  def follow!(other_user)
    if !following?(other_user)
      relationships.create!(followed_id: other_user.id)
    end
  end

  def mutual_follow!(other_user)
    self.follow!(other_user)
    other_user.follow!(self)
  end

  def unfollow!(other_user)
    relationship = self.relationships.find_by(followed_id: other_user.id)
    if relationship
      relationship.destroy
    end
  end

end
