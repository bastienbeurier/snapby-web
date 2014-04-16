class CreateSnapbies < ActiveRecord::Migration
  def change
    create_table :snapbies do |t|
      t.float :lat
      t.float :lng
      t.string :description

      t.timestamps
    end
  end
end
