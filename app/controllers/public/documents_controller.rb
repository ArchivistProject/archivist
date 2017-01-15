class Public::DocumentsController < ApplicationController
  def create
    rev = Revision.new
    doc = Document.new

    group = MetadataGrouping.new
    group.name = MetadataGrouping::GENERIC
    puts params
    [[:title,'string'], [:author,'string'], [:date_added,'date']].each do |n,t|
      field = MetadataField.new
      field.name = "#{n}"
      field.type = t
      field.data = params[n] unless t == 'date'
      field.data = DateTime.now if  t == 'date'
      group.metadata_fields << field
      field.save!
    end
    puts 'foo'
    puts doc
    doc.metadata_groupings << group
    group.save!
    rev.documents << doc
    doc.save!


    rev.save!
  end
end
