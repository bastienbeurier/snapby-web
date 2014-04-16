class AddSnapbyCreatedAtToRemovedSnapby < ActiveRecord::Migration
  def change
  	add_column :removed_snapbies, :snapby_created_at, :datetime
  end
end
