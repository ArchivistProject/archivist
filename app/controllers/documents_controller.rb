class DocumentsController < ApplicationController
  include PaginationController

  def index
    docs = Document.all.paginate(page: params[:page], per_page: 10)
    render json: docs, meta: pagination_dict(docs)
  end

  def show
    render json: document
  end

  def update
    attrs = params.require(:document).permit(:description, tags: [])

    document.update_attributes(attrs[:description]) if attrs[:description]
    document.update_tags attrs[:tags] if attrs[:tags]
  end

  private

  def document
    @document ||= Document.find(params[:id])
  end
end
