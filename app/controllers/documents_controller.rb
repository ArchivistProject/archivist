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

  def search
    docs = Document

    if !params[:item_type].nil?
      doc_ids = MetadataGroup.where(name: params[:item_type]).pluck(:document)
      docs = docs.where(:id.in => doc_ids)
    end

    if !params[:fields].nil?
      names = params[:fields].keys
      values = params[:fields]# hash of names to values
      group_ids = []
      fields = MetadataField.where(:name.in => names).each do |field|
        group_ids << field.metadata_group_id if values[field.name] == field.value # add function for this in MetadataField to take care of the date
      end
      doc_ids = MetadataGroup.where(:id.in => group_ids).pluck(:document)
      docs = docs.where(:id.in => doc_ids)
    end

    if !params[:tags].nil?
      doc_ids = Tag.where(:name.in => params[:tags]).pluck(:document)
      docs = docs.where(:id.in => doc_ids)
    end

    if !params[:description].nil?
      docs = docs.where(description: /#{params[:description]}/)
    end

    docs_to_show = docs.paginate(page: params[:page], per_page: 10)
    render json: docs_to_show, meta: pagination_dict(docs_to_show), root: 'documents'
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
