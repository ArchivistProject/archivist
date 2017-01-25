class MetadataFieldsController < ApplicationController
  def types
    render json: { types: MetadataField.types }
  end
end
