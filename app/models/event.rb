class Event < ApplicationRecord
  belongs_to :created_by, class_name: 'User'
  has_many :event_participants, dependent: :destroy
  has_many :participants, through: :event_participants, source: :user
  has_many :secret_santa_assignments, dependent: :destroy

  validates :name, presence: true
  validates :created_by, presence: true

  def assignments_complete?
    assignments_generated && secret_santa_assignments.count == event_participants.count
  end
end
