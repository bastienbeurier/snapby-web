class AddShoutCountToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :shout_count, :integer, default: 0
  end
end
