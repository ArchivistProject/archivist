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

  def search
    docs = Document

    unless params[:item_types].nil?
      doc_ids = MetadataGroup.where(:name.in => params[:item_types]).pluck(:document)
      docs = docs.where(:id.in => doc_ids)
    end

      names = params[:fields].keys
      values = params[:fields]# hash of names to values
      group_ids = []
      fields = MetadataField.where(:name.in => names).each do |field|
        group_ids << field.metadata_group_id if values[field.name] == field.value # add function for this in MetadataField to take care of the date
      end
      doc_ids = MetadataGroup.where(:id.in => group_ids).pluck(:document)
    unless params[:fields].nil?
      docs = docs.where(:id.in => doc_ids)
    end

    unless params[:tags].nil?
      doc_ids = Tag.where(:name.in => params[:tags]).pluck(:document)
      docs = docs.where(:id.in => doc_ids)
    end

    unless params[:description].nil?
      docs = docs.where(description: /#{params[:description]}/)
    end

    docs_to_show = docs.paginate(page: params[:page], per_page: 10)
    render json: docs_to_show, meta: pagination_dict(docs_to_show), root: 'documents'
  end

  def show_content
    send_data document.file_storage.read, type: document.file_storage.content_type, disposition: 'inline'
  end

  private

  def document
    @document ||= Document.find(params[:id])
  end
end
