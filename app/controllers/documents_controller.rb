class DocumentsController < ApplicationController
  def index
    render json: Document.all, include: 'metadata_groupings.metadata_fields'
  end
end
