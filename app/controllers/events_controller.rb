class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :generate_assignments, :reset_assignments]
  before_action :require_event_creator, only: [:edit, :update, :destroy, :generate_assignments, :reset_assignments]

  def index
    @events = current_user.participating_events.order(event_date: :desc)
  end

  def show
    # Sort participants with host first, then alphabetically
    @participants = @event.participants.sort_by do |p|
      [p == @event.created_by ? 0 : 1, p.name.downcase]
    end
    @is_creator = current_user.can_manage_event?(@event)
    @is_participant = current_user.participating_in?(@event)
    @assignment = current_user.assignment_for_event(@event) if @is_participant
    @receiver = @assignment&.receiver
    @blocks = @event.event_block_lists if @is_creator

    # Get all assignments for the creator to view
    if @is_creator && @event.assignments_generated
      @all_assignments = @event.secret_santa_assignments.includes(:giver, :receiver).order('users.name')
    end

    # Check if there are available users to add
    if @is_creator && !@event.assignments_generated
      @has_available_users = User.where.not(id: @participants.pluck(:id)).exists?
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.created_by = current_user

    if @event.save
      # Automatically add creator as participant
      @event.add_participant(current_user)
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: 'Event was successfully deleted.'
  end

  def generate_assignments
    if @event.generate_assignments!
      redirect_to @event, notice: 'Secret Santa assignments have been generated!'
    else
      redirect_to @event, alert: 'Could not generate assignments. Need at least 3 participants or no valid assignment found.'
    end
  end

  def reset_assignments
    @event.reset_assignments!
    redirect_to @event, notice: 'Assignments have been reset.'
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def require_event_creator
    unless current_user.can_manage_event?(@event)
      redirect_to @event, alert: 'Only the event creator can perform this action.'
    end
  end

  def event_params
    params.require(:event).permit(:name, :description, :event_date, :budget)
  end
end
