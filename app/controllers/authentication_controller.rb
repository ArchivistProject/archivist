class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def login
    user = User.find_by(email: params[:email])

    if user.nil?
      render json: { error: 'Invalid email' }, status: :unauthorized
    elsif !user.authenticate(params[:password])
      render json: { error: 'Invalid Password' }, status: :unauthorized
    else
      render json: { auth_token: JsonWebToken.encode(user_id: user.id) }
    end
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
