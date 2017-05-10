module SortController
  extend ActiveSupport::Concern

  def order(docs)
    if params[:sort_column] && params[:sort_order]
      order = case params[:sort_order]
              when 'ascending'
                :asc
              when 'descending'
                :desc
              else
                raise 'Unknown sort order'
              end
      docs.order("search_fields.#{params[:sort_column]}" => order)
    else
      docs
    end
  end
end
