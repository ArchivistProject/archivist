class MetadataFieldsController < ApplicationController
  def types
    t = MetadataFieldType.constants.map do |c|
      c.to_s if MetadataFieldType.const_get(c).include? Mongoid::Document
    end.compact
    render json: {types: t}
  end
end
