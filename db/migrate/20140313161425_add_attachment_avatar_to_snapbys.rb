class AddAttachmentAvatarToSnapbys < ActiveRecord::Migration
  def self.up
    change_table :snapbys do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :snapbys, :avatar
  end
end
