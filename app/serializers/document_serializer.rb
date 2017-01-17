class DocumentSerializer < ActiveModel::Serializer
  attribute :id

  has_many :metadata_groupings, key: :metadata_fields do
    generic, others = object.metadata_groupings.partition { |g| g.name == MetadataGrouping::GENERIC }
    (generic + others.sort_by(&:name)).inject([]) do |memo, group|
      memo << group.sorted_fields
    end.flatten
  end
end
