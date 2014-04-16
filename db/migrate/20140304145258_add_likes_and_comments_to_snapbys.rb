class AddLikesAndCommentsToSnapbys < ActiveRecord::Migration
  def change
  	add_column :snapbys, :like_count, :integer, default: 0
  	add_column :snapbys, :comment_count, :integer, default: 0
  end
end
