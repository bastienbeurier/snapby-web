class CreateSnapbys < ActiveRecord::Migration
  def change
    create_table :snapbys do |t|
      t.float :lat
      t.float :lng
      t.string :description

      t.timestamps
    end
  end
end
