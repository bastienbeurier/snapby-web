class AddSnapbyCreatedAtToRemovedSnapby < ActiveRecord::Migration
  def change
  	add_column :removed_snapbys, :snapby_created_at, :datetime
  end
end
