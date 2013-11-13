class CreateBlackListedDevices < ActiveRecord::Migration
  def change
    create_table :black_listed_devices do |t|
      t.string :device_id

      t.timestamps
    end
  end
end
