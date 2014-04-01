class Comment < ActiveRecord::Base
  belongs_to :shout

  after_commit :create_activities_and_notifs, on: :create

  validates :shout_id, :shouter_id, :commenter_id, :commenter_username, :description, presence: true

  def create_activities_and_notifs
    CreateCommentActivitiesAndNotificationsWorker.perform_async(self.id)
  end
end
