class Statistics::DocumentsController < ApplicationController
  def index
    render json: { count: docs_count, size: docs_size }
  end

  def count
    render json: { value: docs_count(params[:user_id]) }
  end

  def size
    render json: { value: docs_size(params[:id]) }
  end

  private

  def docs_count(user = nil)
    return Document.all.size unless user
    # TODO: Add user support
    0
  end

  def docs_size(doc_id = nil)
    return Document.find(doc_id).file_storage.size if doc_id

    FileStorage.all.reduce(0) do |total_size, fs|
      total_size += fs.size
    end
  end
end
