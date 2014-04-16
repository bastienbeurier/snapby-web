class AddLikesAndCommentsToSnapbies < ActiveRecord::Migration
  def change
  	add_column :snapbies, :like_count, :integer, default: 0
  	add_column :snapbies, :comment_count, :integer, default: 0
  end
end
