class Headblend < ActiveRecord::Base
  #Interpolation for snapby and user collides because attachment has the same name :avatar
  Paperclip.interpolates :file_name do |attachment, style|
    if attachment.instance.class.to_s == "Snapby"
      "image_" + attachment.instance.id.to_s
    elsif attachment.instance.class.to_s == "Headblend"
      "headblend_" + attachment.instance.id.to_s
    else
      "profile_" + attachment.instance.id.to_s
    end
  end

  # This method associates the attribute ":avatar" with a file attachment
  has_attached_file :avatar, path: ":style/:file_name", bucket: HEADBLEND_BUCKET
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end