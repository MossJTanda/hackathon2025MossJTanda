class EventParticipant < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :event, presence: true
  validates :user, presence: true
  validates :user_id, uniqueness: { scope: :event_id, message: "is already a participant in this event" }
  validate :cannot_join_after_assignments_generated

  def has_assignment?
    event.secret_santa_assignments.exists?(giver: user)
  end

  def assignment
    event.secret_santa_assignments.find_by(giver: user)
  end

  private

  def cannot_join_after_assignments_generated
    if event&.assignments_generated?
      errors.add(:base, "Cannot join event after assignments have been generated")
    end
  end
end
