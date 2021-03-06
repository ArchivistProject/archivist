class ApplicationController < ActionController::API
  before_action :authenticate_request

  def render_success
    render json: { success: true }
  end

  def render_failure
    render json: { success: false }, status: 400
  end

  private

  def validate_token
    authorization = request.headers['Authorization']
    return nil unless authorization.present?

    token = authorization.split(' ').last
    decoded_token = JsonWebToken.decode(token)
    return nil if decoded_token.nil?

    User.find(decoded_token[:user_id])
  rescue
    nil
  end

  def authenticate_request
    @current_user = validate_token
    return render json: { error: 'Invalid token' }, status: 401 if @current_user.nil?
  end
end
