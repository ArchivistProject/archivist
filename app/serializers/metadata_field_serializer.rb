class MetadataFieldSerializer < ActiveModel::Serializer
  belongs_to :metadata_grouping

  attributes :name, :type, :data
end
