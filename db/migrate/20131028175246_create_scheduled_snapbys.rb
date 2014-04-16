class CreateScheduledSnapbies < ActiveRecord::Migration
  def change
    create_table :scheduled_snapbies do |t|
      t.float :lat
      t.float :lng
      t.datetime :scheduled_time
      t.string :description
      t.string :display_name
      t.string :image
      t.string :author

      t.timestamps
    end
  end
end
