class CreateShouts < ActiveRecord::Migration
  def change
    create_table :shouts do |t|
      t.float :lat
      t.float :lng
      t.string :description

      t.timestamps
    end
  end

  def self.up
    add_index  :pages, [:lat, :lng]
  end

  def self.down
    remove_index  :pages, [:lat, :lng]
  end
end
