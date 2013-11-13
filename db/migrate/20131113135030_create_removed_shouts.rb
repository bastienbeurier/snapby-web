class CreateRemovedShouts < ActiveRecord::Migration
  def change
    create_table :removed_shouts do |t|
      t.integer :shout_id
      t.float :lat
      t.float :lng
      t.string :description
      t.string :display_name
      t.string :source
      t.string :device_id
      t.string :image
      t.string :removed_by

      t.timestamps
    end
  end
end
