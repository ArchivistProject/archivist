class DocumentsController < ApplicationController
  include PaginationController
  include PublicAccessibleController

  def index
    docs = Document.all.paginate(page: params[:page], per_page: 10)
    render json: docs, meta: pagination_dict(docs)
  end

  def show
    render json: document
  end

  def create
    create_doc(params)
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
    attrs = params.require(:document).permit(:count, tags: [])
    tags = attrs[:count].to_s == 0.to_s ? [] : attrs[:tags]
    document.update_tags(tags)
    render_success
  end

  def show_content
    send_data document.file_storage.read, type: document.file_storage.content_type, disposition: 'inline'
  end

  private

  def document
    @document ||= Document.find(params[:id])
  end
end
