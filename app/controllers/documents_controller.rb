class DocumentsController < ApplicationController
  include PaginationController
  include PublicAccessibleController
  include SortController

  def index
    s = Setting.global

    docs = Document.all
    paged_docs = order(docs).paginate(page: params[:page], per_page: s.docs_per_page)
    render json: paged_docs, meta: pagination_dict(paged_docs)
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
