class AddHeadblendTable < ActiveRecord::Migration
  def change
    create_table :headblends do |t|
      t.attachment :avatar

      t.timestamps
    end
  end
end
