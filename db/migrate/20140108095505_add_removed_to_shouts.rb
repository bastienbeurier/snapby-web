class AddRemovedToShouts < ActiveRecord::Migration
  def change
    add_column :shouts, :removed, :boolean, default: false
  end
end
