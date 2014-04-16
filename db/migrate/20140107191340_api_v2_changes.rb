class ApiV2Changes < ActiveRecord::Migration
  def change
  	add_column :removed_snapbys, :user_id, :integer
  	remove_column :snapbys, :is_born
  	add_column :snapbys, :username, :string
  end
end
