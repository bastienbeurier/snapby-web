class AddAnonymousToSnapbys < ActiveRecord::Migration
  def change
    add_column :snapbys, :anonymous, :boolean, default: false
  end
end
