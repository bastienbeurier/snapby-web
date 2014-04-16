class AddRemovedToSnapbies < ActiveRecord::Migration
  def change
    add_column :snapbies, :removed, :boolean, default: false
  end
end
