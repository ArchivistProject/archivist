class MetadataGrouping < MongoidBase
  GENERIC = 'Generic'

  belongs_to :document

  field :name, type: String

  has_many :metadata_fields

  def sorted_fields
    self.metadata_fields.order(name: :asc)
  end
end
