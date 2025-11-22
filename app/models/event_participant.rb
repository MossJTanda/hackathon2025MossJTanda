class EventParticipant < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :event, presence: true
  validates :user, presence: true
  validates :user_id, uniqueness: { scope: :event_id, message: "is already a participant in this event" }
end
