class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :shout_id
      t.integer :liker_id
      t.string :liker_username
      t.float :lat
      t.float :lng

      t.timestamps
    end

    add_index :likes, :shout_id
  end
end

