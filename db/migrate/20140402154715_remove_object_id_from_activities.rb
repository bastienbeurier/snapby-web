class RemoveObjectIdFromActivities < ActiveRecord::Migration
  def change
  	remove_column :activities, :object_id
  end
end
