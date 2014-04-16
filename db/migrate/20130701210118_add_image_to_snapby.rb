class AddImageToSnapby < ActiveRecord::Migration
  def change
  	add_column :snapbies, :image, :string
  end
end
