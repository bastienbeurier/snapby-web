class AddSnapbyCountToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :snapby_count, :integer, default: 0
  end
end
