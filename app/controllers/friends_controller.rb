class FriendsController < ApplicationController
  before_action :require_authenticated_user

  def index
    @friends = current_user.friends.order(:username)
  end

  def new
    # Show list of users that can be added as friends
    @available_users = User.where.not(id: current_user.id)
                           .where.not(id: current_user.friends.pluck(:id))
                           .where.not(id: current_user.sent_friend_requests.pending.pluck(:recipient_id))
                           .where.not(id: current_user.received_friend_requests.pending.pluck(:requester_id))
                           .order(:username)
  end

  def destroy
    friend = current_user.friends.find(params[:id])

    # Remove bidirectional friendship
    Friendship.where(user: current_user, friend: friend).destroy_all
    Friendship.where(user: friend, friend: current_user).destroy_all

    redirect_to friends_path, notice: "#{friend.username} has been removed from your friends list"
  end
end
