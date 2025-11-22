class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true

  has_many :reviews

  # Secret Santa associations
  has_many :created_events, class_name: 'Event', foreign_key: 'created_by_id', dependent: :destroy
  has_many :event_participants, dependent: :destroy
  has_many :participating_events, through: :event_participants, source: :event
  has_many :given_assignments, class_name: 'SecretSantaAssignment', foreign_key: 'giver_id', dependent: :destroy
  has_many :received_assignments, class_name: 'SecretSantaAssignment', foreign_key: 'receiver_id', dependent: :destroy
  has_many :blocking_users, class_name: 'EventBlockList', foreign_key: 'blocker_id', dependent: :destroy
  has_many :blocked_by_users, class_name: 'EventBlockList', foreign_key: 'blocked_id', dependent: :destroy

  # Friendship associations
  has_many :sent_friend_requests, class_name: 'FriendRequest', foreign_key: 'requester_id', dependent: :destroy
  has_many :received_friend_requests, class_name: 'FriendRequest', foreign_key: 'recipient_id', dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  def participating_in?(event)
    participating_events.include?(event)
  end

  def created?(event)
    event.created_by == self
  end

  def can_manage_event?(event)
    created?(event)
  end

  def assignment_for_event(event)
    given_assignments.find_by(event: event)
  end

  def receiver_for_event(event)
    assignment = assignment_for_event(event)
    assignment&.receiver
  end

  def has_assignment_for?(event)
    given_assignments.exists?(event: event)
  end

  def blocked_users_for_event(event)
    event.event_block_lists.where(blocker: self).map(&:blocked)
  end

  def upcoming_events
    participating_events.where('event_date >= ?', Date.today).order(:event_date)
  end

  def past_events
    participating_events.where('event_date < ?', Date.today).order(event_date: :desc)
  end

  # Friendship helper methods
  def friends_with?(user)
    friendships.exists?(friend: user)
  end

  def pending_request_to?(user)
    sent_friend_requests.pending.exists?(recipient: user)
  end

  def pending_request_from?(user)
    received_friend_requests.pending.exists?(requester: user)
  end

  def can_send_friend_request_to?(user)
    return false if self == user
    return false if friends_with?(user)
    return false if pending_request_to?(user)
    return false if pending_request_from?(user)
    true
  end
end
