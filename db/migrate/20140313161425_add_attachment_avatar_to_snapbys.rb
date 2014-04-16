class AddAttachmentAvatarToSnapbies < ActiveRecord::Migration
  def self.up
    change_table :snapbies do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :snapbies, :avatar
  end
end
