class HomeController < ApplicationController
  def index
    @upcoming_events = current_user.upcoming_events
    @past_events = current_user.past_events
    @created_events = current_user.created_events.upcoming
  end
end
