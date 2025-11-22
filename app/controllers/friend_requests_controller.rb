class FriendRequestsController < ApplicationController
  before_action :require_authenticated_user

  def index
    @pending_requests = current_user.received_friend_requests.pending.includes(:requester)
    @sent_requests = current_user.sent_friend_requests.pending.includes(:recipient)
  end

  def create
    recipient = User.find(params[:recipient_id])

    unless current_user.can_send_friend_request_to?(recipient)
      redirect_to friend_requests_path, alert: "Cannot send friend request to this user"
      return
    end

    friend_request = current_user.sent_friend_requests.build(recipient: recipient)

    if friend_request.save
      redirect_to friend_requests_path, notice: "Friend request sent to #{recipient.username}"
    else
      redirect_to friend_requests_path, alert: "Could not send friend request"
    end
  end

  def accept
    friend_request = current_user.received_friend_requests.pending.find(params[:id])

    if friend_request.accept!
      redirect_to friend_requests_path, notice: "You are now friends with #{friend_request.requester.username}"
    else
      redirect_to friend_requests_path, alert: "Could not accept friend request"
    end
  end

  def decline
    friend_request = current_user.received_friend_requests.pending.find(params[:id])

    if friend_request.decline!
      redirect_to friend_requests_path, notice: "Friend request declined"
    else
      redirect_to friend_requests_path, alert: "Could not decline friend request"
    end
  end

  def destroy
    friend_request = current_user.sent_friend_requests.pending.find(params[:id])
    friend_request.destroy
    redirect_to friend_requests_path, notice: "Friend request cancelled"
  end
end
