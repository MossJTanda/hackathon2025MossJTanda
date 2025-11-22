class EventBlocksController < ApplicationController
  before_action :set_event
  before_action :require_event_creator

  def create
    blocker = @event.participants.find(params[:blocker_id])
    blocked = @event.participants.find(params[:blocked_id])

    if @event.add_block(blocker, blocked)
      redirect_to @event, notice: "Block added: #{blocker.name} will not be assigned to #{blocked.name}."
    else
      redirect_to @event, alert: 'Could not add block. Please ensure both users are participants.'
    end
  end

  def destroy
    block = @event.event_block_lists.find(params[:id])
    block.destroy

    redirect_to @event, notice: 'Block removed successfully.'
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
