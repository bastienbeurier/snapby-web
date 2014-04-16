class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :snapby_id
      t.integer :liker_id
      t.string :liker_username
      t.float :lat
      t.float :lng

      t.timestamps
    end

    add_index :likes, :snapby_id
  end
end

