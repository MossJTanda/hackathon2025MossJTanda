class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 7 }

  has_many :reviews

  # Secret Santa associations
  has_many :created_events, class_name: 'Event', foreign_key: 'created_by_id', dependent: :destroy
  has_many :event_participants, dependent: :destroy
  has_many :participating_events, through: :event_participants, source: :event
  has_many :given_assignments, class_name: 'SecretSantaAssignment', foreign_key: 'giver_id', dependent: :destroy
  has_many :received_assignments, class_name: 'SecretSantaAssignment', foreign_key: 'receiver_id', dependent: :destroy
end
