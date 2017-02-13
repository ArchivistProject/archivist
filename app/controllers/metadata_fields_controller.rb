class MetadataFieldsController < ApplicationController
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
