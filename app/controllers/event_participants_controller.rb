class EventParticipantsController < ApplicationController
  before_action :set_event

  def create
    user = find_or_invite_user

    if user && @event.add_participant(user)
      redirect_to @event, notice: "#{user.name} has been added to the event."
    else
      redirect_to @event, alert: 'Could not add participant. They may already be participating or assignments have been generated.'
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
    # Try to find by email first
    email = params[:email]
    return nil unless email.present?

    User.find_by(email: email)
  end

  def require_event_creator
    unless current_user.can_manage_event?(@event)
      redirect_to @event, alert: 'Only the event creator can perform this action.'
    end
  end
end
