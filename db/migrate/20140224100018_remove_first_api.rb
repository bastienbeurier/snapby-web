class RemoveFirstApi < ActiveRecord::Migration
  def change
  	remove_column :shouts, :display_name
  	remove_column :shouts, :device_id
  	drop_table :black_listed_devices
  	drop_table :devices
  	drop_table :flagged_shouts
  	drop_table :removed_shouts
  end
end
