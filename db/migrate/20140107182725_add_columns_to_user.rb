class AddColumnsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :username, :string
  	add_column :users, :lat, :float
  	add_column :users, :lng, :float
  	add_column :users, :notification_radius, :integer
  	add_column :users, :device_model, :string
  	add_column :users, :os_version, :string
  	add_column :users, :os_type, :string
  	add_column :users, :app_version, :string
  	add_column :users, :api_version, :string
  	add_column :users, :push_token, :string
  end

  def self.up
    add_index  :users, [:lat, :lng]
    add_index  :snapbies, [:lat, :lng]
  end

  def self.down
    remove_index  :users, [:lat, :lng]
    remove_index  :snapbies, [:lat, :lng]
  end
end
