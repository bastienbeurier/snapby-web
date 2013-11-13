class AddShoutCreatedAtToRemovedShout < ActiveRecord::Migration
  def change
  	add_column :removed_shouts, :shout_created_at, :datetime
  end
end
