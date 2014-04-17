class AddUserScoreAndRemoveLastLikedToSnapbies < ActiveRecord::Migration
  def change
    add_column :snapbies, :user_score, :integer
    remove_column :users, :last_liked
  end
end
