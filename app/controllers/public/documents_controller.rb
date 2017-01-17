class Public::DocumentsController < ApplicationController
  def create
    rev = Revision.new
    doc = Document.new

    group = MetadataGrouping.new
    group.name = MetadataGrouping::GENERIC
    fields = [[:Title, 'string'], [:Author, 'string'], [:Date_Added, 'date']]
    fields.each do |n, t|
      field = MetadataField.new
      field.name = n.to_s.replace('_', ' ')
      field.type = t
      field.data = params[n] unless t == 'date'
      field.data = DateTime.now.utc if t == 'date'
      group.metadata_fields << field
      field.save!
    end
    doc.metadata_groupings << group
    group.save!
    rev.documents << doc
    doc.save!

    rev.save!
  end
end
