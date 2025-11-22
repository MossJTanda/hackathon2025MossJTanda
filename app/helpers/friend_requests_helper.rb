module FriendRequestsHelper
  def pending_friend_requests_count
    return 0 unless current_user
    current_user.received_friend_requests.pending.count
  end
end
