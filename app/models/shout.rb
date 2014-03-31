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

  validates :description, length: { maximum: 140 }
  validates :lat,         presence: true
  validates :lng,         presence: true
  validates :source,      presence: true
  validates :user_id,     presence: true
  validates :username,    presence: true
  #add validates image

  #Interpolation for shout and user collides because attachment has the same name :avatar
  Paperclip.interpolates :file_name do |attachment, style|
    if attachment.instance.class.to_s == "Shout"
      "image_#{attachment.instance.id.to_s}--400"
    else 
      "profile_" + attachment.instance.id.to_s
    end
  end

  # This method associates the attribute ":avatar" with a file attachment
  has_attached_file :avatar, styles: { small: '145x220#' }, path: ":style/:file_name"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def make_trending
    self.update_attributes(trending: true)

    begin    
      PushNotification.notify_trending_shout(self)
    rescue Exception => e
      Airbrake.notify(e)
    end
  end

  def response_shout
    { id: self.id,
      lat: self.lat,
      lng: self.lng, 
      description: self.description,
      created_at: self.created_at,
      image: self.image,
      user_id: self.user_id,
      username: self.username,
      removed: self.removed,
      anonymous: self.anonymous,
      trending: self.trending,
      like_count: self.like_count,
      comment_count: self.comment_count,
      source: "dummy" }
  end

  def self.response_shouts(shouts)
    shouts.map { |shout| shout.response_shout }
  end
end
