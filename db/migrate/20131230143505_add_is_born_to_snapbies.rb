class AddIsBornToSnapbies < ActiveRecord::Migration
  def change
    add_column :snapbies, :is_born, :boolean, default: false
  end
end
