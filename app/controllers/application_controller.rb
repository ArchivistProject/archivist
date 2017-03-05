class ApplicationController < ActionController::API
  def render_success
    render json: { success: true }
  end

  def render_failure
    render json: { success: false }, status: 400
  end
end
