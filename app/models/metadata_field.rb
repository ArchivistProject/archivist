class MetadataField < MongoidBase
  belongs_to :metadata_group

  after_initialize :update_type
  after_create :update_search_fields
  after_update :update_search_fields

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

  def self.data_matches?(query, data, type)
    case type
    when MetadataField::String::TYPE
      !/#{query.downcase}/.match(data.downcase).nil?
    when MetadataField::Date::TYPE
      data == query
    end
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

  def update_search_fields
    # TODO: limit this to only certain fields defined on the frontend
    doc_id = MetadataGroup.pluck_from(metadata_group_id, :document_id)
    doc = Document.find(doc_id)
    doc.search_fields[name] = search_data #TODO: convert data?
    doc.save!
  end

  def search_data
    return nil if data.nil?

    case type
    when MetadataField::String::TYPE
      data.downcase
    else
      data
    end
  end
end
