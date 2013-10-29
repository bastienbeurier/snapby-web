class AddAvatarToScheduledShouts < ActiveRecord::Migration
  def self.up
    add_attachment :scheduled_shouts, :avatar
  end

  def self.down
    remove_attachment :scheduled_shouts, :avatar
  end
end
