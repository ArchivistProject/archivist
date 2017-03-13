class System::SettingsController < ApplicationController
  def index
    s = Setting.global

    render json: s
  end

  def api_key
    @current_user.generate_api_key if params[:refresh]
    render json: { apiToken: @current_user.api_key }
  end

  def update
    s = Setting.global
    s.docs_per_page = params[:docs_per_page]
    s.save!

    render_success
  end
end
