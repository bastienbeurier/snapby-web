class AddIndexToFacebookIdToUser < ActiveRecord::Migration
  def change
  	add_index :user, :facebook_id
  end
end
