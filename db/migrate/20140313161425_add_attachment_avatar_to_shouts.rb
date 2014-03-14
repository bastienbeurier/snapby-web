class AddAttachmentAvatarToShouts < ActiveRecord::Migration
  def self.up
    change_table :shouts do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :shouts, :avatar
  end
end
