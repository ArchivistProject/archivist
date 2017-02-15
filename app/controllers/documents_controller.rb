class DocumentsController < ApplicationController
  include PaginationController

  def index
    docs = Document.all.paginate(page: params[:page], per_page: 10)
    render json: docs, meta: pagination_dict(docs)
  end

  def show
    render json: document
  end

  def show_description
    render json: { document: { description: document.description } }
  end

  def update_description
    document.update_attributes(params.require(:document).permit(:description))
    render_success
  end

  def show_tags
    render json: { document: { tags: document.tag_names } }
  end

  def update_tags
    document.update_tags(params.require(:document).permit(tags: []))
    render_success
  end

  private

  def document
    @document ||= Document.find(params[:id])
  end
end
