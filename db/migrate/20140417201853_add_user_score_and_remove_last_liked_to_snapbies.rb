class AddUserScoreAndRemoveLastLikedToSnapbies < ActiveRecord::Migration
  def change
    add_column :snapbies, :user_score, :integer
    remove_column :snapbies, :last_liked
  end
end
