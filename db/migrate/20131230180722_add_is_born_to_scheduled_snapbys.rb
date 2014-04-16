class AddIsBornToScheduledSnapbies < ActiveRecord::Migration
  def change
    add_column :scheduled_snapbies, :is_born, :boolean, default: false
  end
end
