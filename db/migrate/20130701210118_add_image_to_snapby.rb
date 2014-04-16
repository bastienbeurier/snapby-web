class AddImageToSnapby < ActiveRecord::Migration
  def change
  	add_column :snapbys, :image, :string
  end
end
