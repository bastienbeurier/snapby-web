class AddTrendingToSnapby < ActiveRecord::Migration
  def change
  	add_column :snapbies, :trending, :boolean, default: false
  end
end
