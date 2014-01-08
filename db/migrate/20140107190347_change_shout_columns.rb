class ChangeShoutColumns < ActiveRecord::Migration
  def change
  	add_column :shouts, :user_id, :integer
  end
end
