class Document < MongoidBase
  include Taggable

  belongs_to :revision

  has_one :file_storage, autobuild: true
  has_many :notes
  has_many :metadata_groups, dependent: :destroy do
    def generic
      find_by(name: MetadataGroup::GENERIC)
    end
  end

  field :description, type: String, default: ''

  def add_group(name)
    group = MetadataGroup.new
    group.name = name
    
    metadata_groups << group

    group
  end

  def add_storage(data)
    raise 'Data is already stored' unless file_storage.read.nil?

    file_storage.file = data
    file_storage.save!
    save!
  end

  def self.create_new_doc
    rev = Revision.new
    doc = rev.add_document

    doc
  end
end
