class DocumentSerializer < ActiveModel::Serializer
  attribute :id

  has_many :metadata_groups, key: :metadata_fields do
    generic, others = object.metadata_groups.partition { |g| g.name == MetadataGroup::GENERIC }
    (generic + others.sort_by(&:name)).inject([]) do |memo, group|
      memo << group.sorted_fields
    end.flatten
  end
end
