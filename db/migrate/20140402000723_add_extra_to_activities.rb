class AddExtraToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :extra, :text
  end
end
