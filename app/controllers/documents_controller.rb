class DocumentsController < ApplicationController
  include PaginationController
  include PublicAccessibleController

  def index
    docs = Document.all.paginate(page: params[:page], per_page: 10)
    render json: docs, meta: pagination_dict(docs)
  end

  def show
    render json: document, complete: true
  end

  def create
    create_doc(params)
  end

  def update
    attrs = params.require(:document).permit(:description, :count, tags: [])
    document.update_attributes(attrs.permit(:description))
    # We need count passed in b/c otherwise when tags is empty no params get set
    tags = attrs[:tags].nil? ? [] : attrs[:tags]
    document.update_tags(tags) unless attrs[:count].nil? # without a count we aren't even atttempting to update the tags

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
