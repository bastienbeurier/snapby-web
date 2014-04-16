class ChangeSnapbyColumns < ActiveRecord::Migration
  def change
  	add_column :snapbies, :user_id, :integer
  end
end
