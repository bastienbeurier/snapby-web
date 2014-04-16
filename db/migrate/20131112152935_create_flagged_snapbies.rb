class CreateFlaggedSnapbies < ActiveRecord::Migration
  def change
    create_table :flagged_snapbies do |t|
      t.integer :snapby_id
      t.integer :count
      t.string :motive
      t.string :device_id

      t.timestamps
    end
  end
end
