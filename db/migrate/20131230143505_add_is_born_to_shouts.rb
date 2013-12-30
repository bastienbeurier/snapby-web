class AddIsBornToShouts < ActiveRecord::Migration
  def change
    add_column :shouts, :is_born, :boolean, default: false
  end
end
