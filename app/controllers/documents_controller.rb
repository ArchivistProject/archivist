class DocumentsController < ApplicationController
  def index
    params[:page] ||= 1
    docs = Document.all.paginate(page: params[:page], per_page: 10)
    render json: docs, meta: pagination_dict(docs)
  end

  def show
    render json: Document.find(params[:id])
  end
end
