class AddAvatarToScheduledSnapbys < ActiveRecord::Migration
  def self.up
    add_attachment :scheduled_snapbys, :avatar
  end

  def self.down
    remove_attachment :scheduled_snapbys, :avatar
  end
end
