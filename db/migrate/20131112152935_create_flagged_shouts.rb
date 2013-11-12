class CreateFlaggedShouts < ActiveRecord::Migration
  def change
    create_table :flagged_shouts do |t|
      t.integer :shout_id
      t.integer :count
      t.string :motive
      t.string :device_id

      t.timestamps
    end
  end
end
