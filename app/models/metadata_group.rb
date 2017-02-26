class MetadataGroup < MongoidBase
  GENERIC = 'Generic'.freeze
  WEB = 'Website'.freeze

  belongs_to :document

  field :name, type: String

  has_many :metadata_fields, dependent: :destroy

  def add_field(name, type, data)
    field = MetadataField.create_new_field(type)
    field.name = name
    field.data = data

    metadata_fields << field

    field
  end

  def sorted_fields
    metadata_fields.order(name: :asc)
  end
end
