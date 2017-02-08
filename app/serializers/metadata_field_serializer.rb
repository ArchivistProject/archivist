class MetadataFieldSerializer < ActiveModel::Serializer
  belongs_to :metadata_group

  attributes :id,
             :name,
             :type,
             :data
end
