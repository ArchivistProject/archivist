class MetadataFieldSerializer < ActiveModel::Serializer
  belongs_to :metadata_grouping

  attributes :id,
             :name,
             :type,
             :data
end
