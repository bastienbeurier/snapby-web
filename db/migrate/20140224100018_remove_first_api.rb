class RemoveFirstApi < ActiveRecord::Migration
  def change
  	remove_column :snapbies, :display_name
  	remove_column :snapbies, :device_id
  	drop_table :black_listed_devices
  	drop_table :devices
  	drop_table :flagged_snapbies
  	drop_table :removed_snapbies
  end
end
