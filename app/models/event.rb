class Event < ApplicationRecord
  belongs_to :created_by, class_name: 'User'
  has_many :event_participants, dependent: :destroy
  has_many :participants, through: :event_participants, source: :user
  has_many :secret_santa_assignments, dependent: :destroy
  has_many :event_block_lists, dependent: :destroy

  validates :name, presence: true
  validates :created_by, presence: true
  validate :event_date_cannot_be_in_past, on: :create

  scope :upcoming, -> { where('event_date >= ?', Date.today).order(:event_date) }
  scope :past, -> { where('event_date < ?', Date.today).order(event_date: :desc) }
  scope :with_assignments, -> { where(assignments_generated: true) }
  scope :without_assignments, -> { where(assignments_generated: false) }

  def assignments_complete?
    assignments_generated && secret_santa_assignments.count == event_participants.count
  end

  def blocked_pairing?(user1, user2)
    event_block_lists.exists?(blocker: user1, blocked: user2) ||
    event_block_lists.exists?(blocker: user2, blocked: user1)
  end

  def add_participant(user)
    return false if assignments_generated
    return true if participants.include?(user)

    participants << user
    true
  rescue => e
    false
  end

  def remove_participant(user)
    return false if assignments_generated
    event_participants.find_by(user: user)&.destroy
  end

  def add_block(blocker_user, blocked_user)
    event_block_lists.create(blocker: blocker_user, blocked: blocked_user)
  end

  def remove_block(blocker_user, blocked_user)
    event_block_lists.find_by(blocker: blocker_user, blocked: blocked_user)&.destroy ||
    event_block_lists.find_by(blocker: blocked_user, blocked: blocker_user)&.destroy
  end

  def can_generate_assignments?
    participants.count >= 3 && !assignments_generated
  end

  def generate_assignments!
    return false unless can_generate_assignments?

    ActiveRecord::Base.transaction do
      assignments = find_valid_assignment_chain
      raise ActiveRecord::Rollback unless assignments

      assignments.each do |giver_id, receiver_id|
        secret_santa_assignments.create!(
          giver_id: giver_id,
          receiver_id: receiver_id
        )
      end

      update!(assignments_generated: true)
    end

    assignments_complete?
  end

  def reset_assignments!
    secret_santa_assignments.destroy_all
    update!(assignments_generated: false)
  end

  def assignment_for(user)
    secret_santa_assignments.find_by(giver: user)
  end

  private

  def event_date_cannot_be_in_past
    if event_date.present? && event_date < Date.today
      errors.add(:event_date, "cannot be in the past")
    end
  end

  def find_valid_assignment_chain
    participant_ids = participants.pluck(:id)
    return nil if participant_ids.size < 3

    max_attempts = 100
    max_attempts.times do
      shuffled = participant_ids.shuffle
      valid = true

      shuffled.each_with_index do |giver_id, index|
        receiver_id = shuffled[(index + 1) % shuffled.size]
        giver = participants.find(giver_id)
        receiver = participants.find(receiver_id)

        if blocked_pairing?(giver, receiver)
          valid = false
          break
        end
      end

      if valid
        result = {}
        shuffled.each_with_index do |giver_id, index|
          receiver_id = shuffled[(index + 1) % shuffled.size]
          result[giver_id] = receiver_id
        end
        return result
      end
    end

    nil
  end
end
