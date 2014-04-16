class AddAvatarToScheduledSnapbies < ActiveRecord::Migration
  def self.up
    add_attachment :scheduled_snapbies, :avatar
  end

  def self.down
    remove_attachment :scheduled_snapbies, :avatar
  end
end
