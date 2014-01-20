class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :shout_id
      t.integer :shouter_id
      t.integer :commenter_id
      t.string :commenter_username
      t.string :description
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
