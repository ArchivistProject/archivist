class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def login
    user = User.find_by(email: params[:email])
    raise unless user.authenticate(params[:password])
    render json: { auth_token: JsonWebToken.encode(user_id: user.id) }
  rescue
    render json: { error: 'Invalid email/password' }, status: :unauthorized
  end

  def status
    user = validate_token
    if user.nil?
      render json: { valid: false }
    else
      render json: { valid: true }
    end
  end
end
