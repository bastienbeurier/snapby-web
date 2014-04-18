class AddCommenterScoreToComments < ActiveRecord::Migration
  def change
  	add_column :comments, :commenter_score, :integer
  end
end
