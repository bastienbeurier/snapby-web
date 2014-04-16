class Snapby < ActiveRecord::Base
  has_many :flags, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  belongs_to :user

  after_commit :create_activities_and_notifs, on: :create
  
  acts_as_mappable  :default_units => :kms, 
                    :default_formula => :sphere, 
                    :distance_field_name => :distance,
                    :lat_column_name => :lat,
                    :lng_column_name => :lng

  validates :lat,         presence: true
  validates :lng,         presence: true
  validates :source,      presence: true
  validates :user_id,     presence: true
  validates :username,    presence: true

  def create_activities_and_notifs
    CreateSnapbyActivitiesAndNotificationsWorker.perform_async(self.id)
  end

  #Interpolation for snapby and user collides because attachment has the same name :avatar
  Paperclip.interpolates :file_name do |attachment, style|
    if attachment.instance.class.to_s == "Snapby"
      "image_#{attachment.instance.id.to_s}--400"
    else 
      "profile_" + attachment.instance.id.to_s
    end
  end

  # This method associates the attribute ":avatar" with a file attachment
  has_attached_file :avatar, styles: { small: '145x220#' }, path: ":style/:file_name"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def response_snapby
    { id: self.id,
      lat: self.lat,
      lng: self.lng, 
      created_at: self.created_at,
      user_id: self.user_id,
      username: self.username,
      removed: self.removed,
      anonymous: self.anonymous,
      like_count: self.like_count,
      comment_count: self.comment_count,
      source: "dummy" }
  end

  def self.response_snapbies(snapbies)
    snapbies.map { |snapby| snapby.response_snapby }
  end
end
