class AddIsBornToScheduledSnapbys < ActiveRecord::Migration
  def change
    add_column :scheduled_snapbys, :is_born, :boolean, default: false
  end
end
