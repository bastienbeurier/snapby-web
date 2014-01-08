class ApiV2Changes < ActiveRecord::Migration
  def change
  	add_column :removed_shouts, :user_id, :integer
  	remove_column :shouts, :is_born
  	add_column :shouts, :username, :string
  end
end
