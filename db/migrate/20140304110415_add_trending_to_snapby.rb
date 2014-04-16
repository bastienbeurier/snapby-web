class AddTrendingToSnapby < ActiveRecord::Migration
  def change
  	add_column :snapbys, :trending, :boolean, default: false
  end
end
