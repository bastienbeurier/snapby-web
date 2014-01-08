class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device_id
      t.string :push_token
      t.float :lat
      t.float :lng
      t.integer :notification_radius
      t.string :device_model
      t.string :os_version
      t.string :os_type
      t.string :app_version
      t.string :api_version

      t.timestamps
    end
  end

  def self.up
    add_index  :devices, [:lat, :lng]
  end

  def self.down
    remove_index  :devices, [:lat, :lng]
  end
end
