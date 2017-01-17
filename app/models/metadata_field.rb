class MetadataField < MongoidBase
  belongs_to :metadata_grouping

  field :name,                  type: String
  field :type,                  type: String
  field :data,                  type: Object
  field :last_updated,          type: DateTime
  field :constant,              type: Boolean
  field :constant_after_upload, type: Boolean

  def string?
    type == MetadataFieldType::String::TYPE
  end

  def date?
    type == MetadataFieldType::Date::TYPE
  end
end
