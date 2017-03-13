class MetadataFieldsController < ApplicationController
  include AclController

  before_action only: [:update] { |c| verify(metadata_field.metadata_group.document, :be_edited?) }

  def update
    metadata_field.update_attributes(params.require(:metadata_field).permit(:data))
    render_success
  end

  def types
    render json: { types: MetadataField.types }
  end

  private

  def metadata_field
    @metadata_field ||= MetadataField.find(params[:id])
  end
end
