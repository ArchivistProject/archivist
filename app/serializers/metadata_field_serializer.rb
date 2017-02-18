class MetadataFieldSerializer < ActiveModel::Serializer
  belongs_to :metadata_group

  attributes :id,
             :name,
             :type,
             :data,
             :group

  def group
    object.metadata_group.name
  end
end
