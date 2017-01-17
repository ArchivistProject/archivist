class Document < MongoidBase
  belongs_to :revision

  has_one :document_storage
  has_one :tag_array

  has_many :notes
  has_many :metadata_groupings

  def add_group(name)
    group = MetadataGrouping.new
    group.name = name
    metadata_groupings << group
    group.save!
    save!

    group
  end
end
