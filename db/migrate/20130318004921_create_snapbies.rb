class CreateSnapbies < ActiveRecord::Migration
  def change
    create_table :snapbies do |t|
      t.float :lat
      t.float :lng
      t.string :description
      t.string :source
      t.integer :user_id
      t.boolean :removed, default: false
      t.boolean :anonymous, default: false
      t.integer :like_count, default: 0
      t.integer :comment_count, default: 0
      t.datetime :last_liked
      t.datetime :last_active

      t.timestamps
    end

    add_index :snapbies, [:lat, :lng]
    add_index :snapbies, :last_liked
  end
end
