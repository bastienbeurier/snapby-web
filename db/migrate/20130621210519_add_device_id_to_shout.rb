class AddDeviceIdToShout < ActiveRecord::Migration
  def change
  	add_column :shouts, :device_id, :string
  end
end
