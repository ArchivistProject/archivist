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

  def self.create_new_field(new_type)
    MetadataField.type_models.map do |t|
      return t.new if new_type == t::TYPE
    end
    raise 'Unkown MetadataField type: ' + new_type
  end

  def self.types
    MetadataField.type_models.map do |t|
      t::TYPE
    end
  end

  private_class_method def self.type_models
    MetadataFieldType.constants.map do |c|
      t = MetadataFieldType.const_get(c)
      t if t.include? Mongoid::Document
    end.compact
  end

  private

  def update_type
    return unless new_record?
    raise 'Must be instantiated in a specific type' if self.class == MetadataField
    self.type ||= self.class::TYPE
  end
end
