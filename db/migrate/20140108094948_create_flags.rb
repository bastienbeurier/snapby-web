class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
    	t.integer :shout_id
    	t.string  :motive
    	t.integer :flagger_id
    end
  end
end
