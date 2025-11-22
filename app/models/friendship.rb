class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :friend_id, uniqueness: { scope: :user_id }
  validate :cannot_friend_yourself

  private

  def cannot_friend_yourself
    if user_id == friend_id
      errors.add(:base, "You cannot be friends with yourself")
    end
  end
end
