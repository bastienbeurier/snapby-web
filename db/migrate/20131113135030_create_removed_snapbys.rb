class CreateRemovedSnapbys < ActiveRecord::Migration
  def change
    create_table :removed_snapbys do |t|
      t.integer :snapby_id
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
