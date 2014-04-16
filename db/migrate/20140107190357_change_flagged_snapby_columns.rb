class ChangeFlaggedSnapbyColumns < ActiveRecord::Migration
  def change
  	add_column :flagged_snapbies, :user_ids, :string
  	remove_column :flagged_snapbies, :count
  end
end
