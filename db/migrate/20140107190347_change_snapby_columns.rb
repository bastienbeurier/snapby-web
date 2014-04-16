class ChangeSnapbyColumns < ActiveRecord::Migration
  def change
  	add_column :snapbys, :user_id, :integer
  end
end
