class CreateShouts < ActiveRecord::Migration
  def change
    create_table :shouts do |t|
      t.float :lat
      t.float :lng
      t.string :description

      t.timestamps
    end
  end
end
