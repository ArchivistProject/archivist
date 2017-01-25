class DocumentsController < ApplicationController
  include PaginationController

  def index
    docs = Document.all.paginate(page: params[:page], per_page: 10)
    render json: docs, meta: pagination_dict(docs)
  end

  def show
    render json: Document.find(params[:id])
  end
end
