class EventBlockList < ApplicationRecord
  belongs_to :event
  belongs_to :blocker, class_name: 'User'
  belongs_to :blocked, class_name: 'User'

  validates :event, presence: true
  validates :blocker, presence: true
  validates :blocked, presence: true
  validates :blocker_id, uniqueness: { scope: [:event_id, :blocked_id], message: "already has this person blocked in this event" }
  validate :cannot_block_self
  validate :both_must_be_participants

  private

  def cannot_block_self
    if blocker_id == blocked_id
      errors.add(:blocked, "cannot block yourself")
    end
  end

  def both_must_be_participants
    return unless event && blocker_id && blocked_id

    unless event.participants.exists?(blocker_id)
      errors.add(:blocker, "must be a participant in this event")
    end

    unless event.participants.exists?(blocked_id)
      errors.add(:blocked, "must be a participant in this event")
    end
  end
end
