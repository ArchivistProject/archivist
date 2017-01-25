module PaginationController
  extend ActiveSupport::Concern

  included do
    before_action :set_default_page
  end

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

  def set_default_page
    params[:page] ||= 1
  end
end
