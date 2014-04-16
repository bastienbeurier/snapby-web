class AddSourceAndDisplayNameToSnapbys < ActiveRecord::Migration
  def change
    add_column :snapbys, :display_name, :string
    add_column :snapbys, :source, :string
  end
end
