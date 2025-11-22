class Api::V1::AuthController < Api::V1::ApiController
  skip_before_action :authenticate_request, only: [:login]

  def login
    username = params[:username]&.strip&.downcase

    if username.blank?
      render json: { error: 'Username is required' }, status: :bad_request
      return
    end

    user = User.find_or_create_by(username: username) do |u|
      u.name = username.titleize
      u.email = "#{username}@secretsanta.com"
    end

    if user.persisted?
      token = encode_token(user.id)
      render json: {
        token: token,
        user: {
          id: user.id,
          username: user.username,
          email: user.email,
          name: user.name
        }
      }, status: :ok
    else
      render json: { error: 'Could not create account' }, status: :unprocessable_entity
    end
  end

  def refresh
    token = encode_token(current_user.id)
    render json: {
      token: token,
      user: {
        id: current_user.id,
        email: current_user.email,
        name: current_user.name
      }
    }, status: :ok
  end
end
