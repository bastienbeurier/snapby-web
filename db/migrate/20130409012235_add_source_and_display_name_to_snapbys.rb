class AddSourceAndDisplayNameToSnapbies < ActiveRecord::Migration
  def change
    add_column :snapbies, :display_name, :string
    add_column :snapbies, :source, :string
  end
end
