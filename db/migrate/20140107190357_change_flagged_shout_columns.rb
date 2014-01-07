class ChangeFlaggedShoutColumns < ActiveRecord::Migration
  def change
  	add_column :flagged_shouts, :user_ids, :string
  	remove_column :flagged_shouts, :count
  end
end
