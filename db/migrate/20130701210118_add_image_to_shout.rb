class AddImageToShout < ActiveRecord::Migration
  def change
  	add_column :shouts, :image, :string
  end
end
