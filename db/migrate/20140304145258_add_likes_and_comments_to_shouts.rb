class AddLikesAndCommentsToShouts < ActiveRecord::Migration
  def change
  	add_column :shouts, :like_count, :integer, default: 0
  	add_column :shouts, :comment_count, :integer, default: 0
  end
end
