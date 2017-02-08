class MetadataField < MongoidBase
  belongs_to :metadata_group

  after_initialize :update_type

  field :name,                  type: String
  field :type,                  type: String
  field :data,                  type: Object
  field :last_updated,          type: DateTime
  field :constant,              type: Boolean
  field :constant_after_upload, type: Boolean

  def string?
    type == MetadataField::String::TYPE
  end

  def date?
    type == MetadataField::Date::TYPE
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

  #TODO: should be private
  def self.type_models
    MetadataField.constants.map do |c|
      t = MetadataField.const_get(c)
      t if t.to_s.starts_with?('MetadataField') && t.include?(Mongoid::Document)
    end.compact
  end

  private

  def update_type
    return unless new_record?
    raise 'Must be instantiated in a specific type' if self.class == MetadataField
    self.type ||= self.class::TYPE
  end
end
