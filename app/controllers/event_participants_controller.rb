class EventParticipantsController < ApplicationController
  before_action :set_event
  before_action :require_event_creator, only: [:new, :create]

  def new
    # Only show friends of the event creator who are not already participants
    @available_users = current_user.friends
                                   .where.not(id: @event.participants.pluck(:id))
                                   .order(:username)
  end

  def create
    user = find_or_invite_user

    if user && @event.add_participant(user)
      redirect_to event_add_participant_path(@event), notice: "#{user.name} has been added to the event."
    else
      redirect_to event_add_participant_path(@event), alert: 'Could not add participant. They may already be participating or assignments have been generated.'
    end
  end

  def destroy
    participant = @event.participants.find(params[:id])

    if @event.remove_participant(participant)
      redirect_to @event, notice: 'Participant removed successfully.'
    else
      redirect_to @event, alert: 'Cannot remove participant after assignments have been generated.'
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def find_or_invite_user
    # Try to find by username
    username = params[:username]&.strip&.downcase
    return nil unless username.present?

    # Find or create user by username (same as login flow)
    User.find_or_create_by(username: username) do |u|
      u.name = username.titleize
      u.email = "#{username}@secretsanta.com"
    end
  end

  def require_event_creator
    unless current_user.can_manage_event?(@event)
      redirect_to @event, alert: 'Only the event creator can perform this action.'
    end
  end
end
