class MetadataFieldSerializer < ActiveModel::Serializer
  belongs_to :metadata_group

  attributes :id,
             :name,
             :type,
             :data,
             :group,
             :group_id

  def group
    object.metadata_group.name
  end

  def group_id
    object.metadata_group.id
  end
end
