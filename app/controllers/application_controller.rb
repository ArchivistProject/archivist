class ApplicationController < ActionController::API
  before_action :authenticate_request

  def pagination_dict(object)
    {
      current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.previous_page,
      total_pages: object.total_pages,
      total_count: object.total_entries
    }
  end

  private

  def validate_token
    authorization = request.headers['Authorization']
    return nil unless authorization.present?

    token = authorization.split(' ').last
    decoded_token = JsonWebToken.decode(token)
    return nil if decoded_token.nil?

    User.find(decoded_token[:user_id])
  end

  def authenticate_request
    @current_user = validate_token
    return render json: { error: 'Invalid token' }, status: 401 if @current_user.nil?
  end
end
