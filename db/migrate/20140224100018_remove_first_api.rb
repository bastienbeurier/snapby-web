class RemoveFirstApi < ActiveRecord::Migration
  def change
  	remove_column :snapbys, :display_name
  	remove_column :snapbys, :device_id
  	drop_table :black_listed_devices
  	drop_table :devices
  	drop_table :flagged_snapbys
  	drop_table :removed_snapbys
  end
end
