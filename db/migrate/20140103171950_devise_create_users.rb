class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Encryptable
      t.string :password_salt

      # Token authenticatable
      t.string :authentication_token

      t.string :username
      t.float :lat
      t.float :lng
      t.string :device_model
      t.string :os_version
      t.string :os_type
      t.string :app_version
      t.string :api_version
      t.string :push_token
      t.string :facebook_id
      t.string :facebook_name
      t.boolean :black_listed, default: false
      t.integer :snapby_count, default: 0
      t.integer :liked_snapbies, default: 0

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :authentication_token, :unique => true
    add_index :users, [:lat, :lng]
  end
end