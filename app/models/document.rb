class Document < MongoidBase
  belongs_to :revision

  has_one :document_storage
  has_one :tag_array

  has_many :notes
  has_many :metadata_groups, dependent: :destroy do
    def generic
      find_by(name: MetadataGroup::GENERIC)
    end
  end

  def add_group(name)
    group = MetadataGroup.new
    group.name = name
    metadata_groups << group
    group.save!
    save!

    group
  end

  def self.create_new_doc
    rev = Revision.new
    doc = rev.add_document

    doc
  end
end
