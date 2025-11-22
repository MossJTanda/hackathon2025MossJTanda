class UsersController < ApplicationController
  skip_before_action :require_authenticated_user, only: [:new, :create]

  def show
    @user = User.find(params[:id])
  end

  def profile
    @user = current_user
    @upcoming_events = current_user.upcoming_events
    @past_events = current_user.past_events
    @created_events = current_user.created_events
  end

  def new
    if current_user.present?
      redirect_to home_path
    end
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to home_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
