class MetadataGroupSerializer < ActiveModel::Serializer
  belongs_to :document
  has_many :metadata_fields

  attribute :name
end
