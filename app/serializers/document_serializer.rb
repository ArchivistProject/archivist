class DocumentSerializer < ActiveModel::Serializer
  attribute :id
  attribute :description, if: :complete?
  attribute :content_type, if: :complete? do
    object.file_storage.content_type
  end

  has_many :tags, if: :complete? do
    object.tag_names
  end

  has_many :metadata_groups, key: :metadata_fields do
    generic, others = object.metadata_groups.partition { |g| g.name == MetadataGroup::GENERIC }
    (generic + others.sort_by(&:name)).inject([]) do |memo, group|
      memo << group.sorted_fields
    end.flatten
  end

  def complete?
    !!instance_options[:complete]
  end
end
