class ChangeFlaggedSnapbyColumns < ActiveRecord::Migration
  def change
  	add_column :flagged_snapbys, :user_ids, :string
  	remove_column :flagged_snapbys, :count
  end
end
