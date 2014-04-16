class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :snapby_id
      t.integer :snapbyer_id
      t.integer :commenter_id
      t.string :commenter_username
      t.string :description
      t.float :lat
      t.float :lng

      t.timestamps
    end

    add_index :comments, :snapby_id
  end
end
