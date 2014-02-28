class AddAnonymousToShouts < ActiveRecord::Migration
  def change
    add_column :shouts, :anonymous, :boolean, default: false
  end
end
