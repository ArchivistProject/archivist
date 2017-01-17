require 'rake'

namespace :factory do
  desc 'Populates the database with sample document data'
  task simple_docs: :environment do
    def create_doc(title, author, date_added)
      rev = Revision.new
      doc = Document.new
      rev.documents << doc
      group = add_group(doc, MetadataGrouping::GENERIC)
      add_field(group, 'Title', 'string', title)
      add_field(group, 'Author', 'string', author)
      add_field(group, 'Date Added', 'date', date_added)

      rev.save!

      doc
    end

    def add_group(doc, name)
      group = MetadataGrouping.new
      group.name = name

      doc.metadata_groupings << group
      group.save!
      doc.save!

      group
    end

    def add_field(group, name, type, data)
      field = MetadataField.new
      field.name = name
      field.type = type
      field.data = data

      group.metadata_fields << field
      field.save!
      group.save!
    end

    doc = create_doc('The Time is Near', 'John Rust', Time.utc(2020, 7, 6, 0, 0, 0))
    group = add_group(doc, 'Not Generic 2')
    add_field(group, 'ZigZag 2', 'string', 'some value')
    add_field(group, 'FooBar 2', 'string', 'some value 2')
    add_field(group, 'Moo 2', 'string', 'some value 3')
    group = add_group(doc, 'Not Generic 1')
    add_field(group, 'ZigZag 1', 'string', 'some value 4')
    add_field(group, 'FooBar 1', 'string', 'some value 5')
    add_field(group, 'Moo 1', 'string', 'some value 6')

    doc = create_doc('What a Time', 'Dr. Alive', Time.utc(2018, 5, 2, 0, 0, 0))
    group = add_group(doc, 'Not Generic 1')
    add_field(group, 'ZigZag 1', 'string', 'far 4')
    add_field(group, 'FooBar 1', 'string', 'far 5')
    add_field(group, 'Moo 1', 'string', 'far 6')

    ('A'..'Z').each do |letter|
      doc = create_doc("Article #{letter}", "Sir #{letter}", Time.utc(2002, 10, 15, 0, 0, 0))
    end
  end
end
