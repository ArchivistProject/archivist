class DocumentSerializer < ActiveModel::Serializer
  has_many :metadata_groupings
end
