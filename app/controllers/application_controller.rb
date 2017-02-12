class ApplicationController < ActionController::API
  def render_success
    render json: { success: true }
  end
end
