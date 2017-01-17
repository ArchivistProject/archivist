class MetadataGrouping < MongoidBase
  GENERIC = 'Generic'.freeze

  belongs_to :document

  field :name, type: String

  has_many :metadata_fields

  def sorted_fields
    metadata_fields.order(name: :asc)
  end
end
