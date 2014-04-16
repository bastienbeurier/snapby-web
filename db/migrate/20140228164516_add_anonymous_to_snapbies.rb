class AddAnonymousToSnapbies < ActiveRecord::Migration
  def change
    add_column :snapbies, :anonymous, :boolean, default: false
  end
end
