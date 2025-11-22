class SessionsController < ApplicationController

  skip_before_action :require_authenticated_user, except: :destroy

  def new
    if current_user.present?
      redirect_to logged_in_path
    end
  end

  def create
    username = params[:username]&.strip&.downcase

    if username.blank?
      flash[:alert] = "Please enter a username"
      redirect_to new_session_path
      return
    end

    user = User.find_or_create_by(username: username) do |u|
      u.name = username.titleize
      u.email = "#{username}@secretsanta.com"
    end

    if user.persisted?
      session[:user_id] = user.id
      redirect_to home_path
    else
      flash[:alert] = "Could not create account. Please try again."
      redirect_to new_session_path
    end
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil

    redirect_to new_session_path
  end
end
