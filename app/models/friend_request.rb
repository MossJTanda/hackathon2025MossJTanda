class FriendRequest < ApplicationRecord
  belongs_to :requester, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  validates :status, inclusion: { in: %w[pending accepted declined] }
  validates :requester_id, uniqueness: { scope: :recipient_id }
  validate :cannot_friend_yourself

  scope :pending, -> { where(status: 'pending') }
  scope :accepted, -> { where(status: 'accepted') }
  scope :declined, -> { where(status: 'declined') }

  def accept!
    transaction do
      update!(status: 'accepted')
      # Create bidirectional friendship
      Friendship.create!(user: requester, friend: recipient)
      Friendship.create!(user: recipient, friend: requester)
    end
  end

  def decline!
    update!(status: 'declined')
  end

  private

  def cannot_friend_yourself
    if requester_id == recipient_id
      errors.add(:base, "You cannot send a friend request to yourself")
    end
  end
end
