class SecretSantaAssignment < ApplicationRecord
  belongs_to :event
  belongs_to :giver, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :event, presence: true
  validates :giver, presence: true
  validates :receiver, presence: true
  validates :giver_id, uniqueness: { scope: :event_id, message: "already has an assignment in this event" }
  validates :receiver_id, uniqueness: { scope: :event_id, message: "is already assigned to someone in this event" }
  validate :cannot_assign_to_self

  private

  def cannot_assign_to_self
    if giver_id == receiver_id
      errors.add(:receiver, "cannot be the same as giver")
    end
  end
end
