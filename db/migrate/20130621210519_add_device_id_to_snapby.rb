class AddDeviceIdToSnapby < ActiveRecord::Migration
  def change
  	add_column :snapbys, :device_id, :string
  end
end
