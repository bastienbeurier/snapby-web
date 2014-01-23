class CreateUserNotification < ActiveRecord::Migration
  def change
    create_table :user_notifications do |t|
    	t.integer :user_id
    	t.integer :sent_count
    	t.datetime :last_sent
    	t.integer :blocked_count

    	t.timestamps
    end
  end
end
