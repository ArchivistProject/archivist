class System::SettingsController < ApplicationController
  def index
    s = Setting.global

    render json: s
  end

  def update
    s = Setting.global
    s.docs_per_page = params[:docs_per_page]
    s.save!

    render_success
  end
end