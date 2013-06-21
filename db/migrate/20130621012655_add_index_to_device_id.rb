class AddIndexToDeviceId < ActiveRecord::Migration
  def up
    add_index :devices, :device_id, :unique => true
  end

  def down
    remove_index :devices, :device_id
  end
end
