class EventBlocksController < ApplicationController
  before_action :set_event
  before_action :require_event_creator

  def edit
    @participant = @event.participants.find(params[:user_id])
    @other_participants = @event.participants.where.not(id: @participant.id)

    # Get current blocks for this participant
    @blocked_user_ids = @event.event_block_lists
      .where(blocker: @participant)
      .pluck(:blocked_id)
  end

  def update
    @participant = @event.participants.find(params[:user_id])
    blocked_ids = params[:blocked_user_ids] || []

    # Remove all existing blocks for this participant
    @event.event_block_lists.where(blocker: @participant).destroy_all

    # Create new blocks
    blocked_ids.each do |blocked_id|
      @event.event_block_lists.create(
        blocker: @participant,
        blocked_id: blocked_id
      )
    end

    redirect_to @event, notice: "Blocks updated for #{@participant.name}"
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def require_event_creator
    unless current_user.can_manage_event?(@event)
      redirect_to @event, alert: 'Only the event creator can manage blocks.'
    end
  end
end
