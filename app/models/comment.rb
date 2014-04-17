class Comment < ActiveRecord::Base
  belongs_to :snapby
  belongs_to :commenter, class_name: 'User'

  after_commit :create_activities_and_notifs, on: :create

  validates :snapby_id, :snapbyer_id, :commenter_id, :commenter_username, :description, presence: true

  def create_activities_and_notifs
    CreateCommentActivitiesAndNotificationsWorker.perform_async(self.id)
  end
end
