class AddIsBornToScheduledShouts < ActiveRecord::Migration
  def change
    add_column :scheduled_shouts, :is_born, :boolean, default: false
  end
end
