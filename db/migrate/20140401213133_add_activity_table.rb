class AddActivityTable < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :subject_id
      t.string :subject_type
      t.string :activity_type
      t.integer :object_id
      t.integer :user_id

      t.timestamps
    end

    add_index :activities, :user_id
  end
end
