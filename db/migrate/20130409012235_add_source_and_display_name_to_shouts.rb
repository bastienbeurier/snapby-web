class AddSourceAndDisplayNameToShouts < ActiveRecord::Migration
  def change
    add_column :shouts, :display_name, :string
    add_column :shouts, :source, :string
  end
end
