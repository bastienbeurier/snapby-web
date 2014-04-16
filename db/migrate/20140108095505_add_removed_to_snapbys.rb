class AddRemovedToSnapbys < ActiveRecord::Migration
  def change
    add_column :snapbys, :removed, :boolean, default: false
  end
end
