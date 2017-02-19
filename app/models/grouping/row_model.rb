class Grouping::Row < MongoidBase
  embedded_in :group

  field :name, type: String
  field :type, type: String

  validates :name, presence: true
  validate do
    errors.add(:type, '"type" must be a MetadataField type') unless type.in? MetadataField.types
  end
end
