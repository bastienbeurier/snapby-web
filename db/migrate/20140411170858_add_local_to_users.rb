class AddLocalToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :local, :boolean, default: false
  end
end
