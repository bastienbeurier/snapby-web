class AddDeviceIdToSnapby < ActiveRecord::Migration
  def change
  	add_column :snapbies, :device_id, :string
  end
end
