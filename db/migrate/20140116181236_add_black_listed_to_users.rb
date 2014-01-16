class AddBlackListedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :black_listed, :boolean, default: false
  end
end
