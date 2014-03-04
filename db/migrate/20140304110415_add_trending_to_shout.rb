class AddTrendingToShout < ActiveRecord::Migration
  def change
  	add_column :shouts, :trending, :boolean, default: false
  end
end
