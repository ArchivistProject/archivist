class MetadataGrouping < MongoidBase
  belongs_to :document

  field :name, type: String

  has_many :metadata_fields
end
