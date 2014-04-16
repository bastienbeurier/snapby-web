class ApiV2Changes < ActiveRecord::Migration
  def change
  	add_column :removed_snapbies, :user_id, :integer
  	remove_column :snapbies, :is_born
  	add_column :snapbies, :username, :string
  end
end
