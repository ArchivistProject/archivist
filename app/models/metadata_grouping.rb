class MetadataGrouping < MongoidBase
  GENERIC = 'Generic'.freeze

  belongs_to :document

  field :name, type: String

  has_many :metadata_fields, dependent: :destroy

  def add_field(name, type, data)
    field = MetadataField.new
    field.name = name
    field.type = type
    field.data = data

    metadata_fields << field
    field.save!
    save!

    field
  end

  def sorted_fields
    metadata_fields.order(name: :asc)
  end
end
