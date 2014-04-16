class AddIsBornToSnapbys < ActiveRecord::Migration
  def change
    add_column :snapbys, :is_born, :boolean, default: false
  end
end
