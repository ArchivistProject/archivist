class MetadataField < MongoidBase
  belongs_to :metadata_grouping

  after_initialize :update_type

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

  def self.create_new_field(t)
    case t
    when MetadataFieldType::String::TYPE
      MetadataFieldType::String.new
    when MetadataFieldType::Date::TYPE
      MetadataFieldType::Date.new
    end
  end

  private

  def update_type
    return if new_record?
    raise 'Must be instantiated in a specific type' if self.class == MetadataField
    self.type ||= self.class::TYPE
  end
end
