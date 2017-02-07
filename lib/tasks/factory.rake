require 'rake'

namespace :factory do
  desc 'Add the system groupings'
  task system_groups: :environment do
    g = Grouping::Group.new(name: MetadataGroup::GENERIC)
    g.rows << Grouping::Row.new(name: 'Title', type: MetadataFieldType::String::TYPE)
    g.rows << Grouping::Row.new(name: 'Author', type: MetadataFieldType::String::TYPE)
    g.rows << Grouping::Row.new(name: 'Date Added', type: MetadataFieldType::Date::TYPE)
    g.rows << Grouping::Row.new(name: 'Date Published', type: MetadataFieldType::Date::TYPE)
    g.rows << Grouping::Row.new(name: 'Item Size', type: MetadataFieldType::String::TYPE)
    g.save!

    g = Grouping::Group.new(name: MetadataGroup::WEB)
    g.rows << Grouping::Row.new(name: 'URL', type: MetadataFieldType::String::TYPE)
    g.save!
  end

  desc 'Populates the database with sample document data'
  task simple_docs: :environment do
    def create_doc(title, author, date_added)
      doc = Document.create_new_doc
      group = doc.add_group(MetadataGroup::GENERIC)
      group.add_field('Title', 'string', title)
      group.add_field('Author', 'string', author)
      group.add_field('Date Added', 'date', date_added)

      doc
    end

    doc = create_doc('The Time is Near', 'John Rust', Time.utc(2020, 7, 6, 0, 0, 0))
    group = doc.add_group('Not Generic 2')
    group.add_field('ZigZag 2', 'string', 'some value')
    group.add_field('FooBar 2', 'string', 'some value 2')
    group.add_field('Moo 2', 'string', 'some value 3')
    group = doc.add_group('Not Generic 1')
    group.add_field('ZigZag 1', 'string', 'some value 4')
    group.add_field('FooBar 1', 'string', 'some value 5')
    group.add_field('Moo 1', 'string', 'some value 6')

    doc = create_doc('What a Time', 'Dr. Alive', Time.utc(2018, 5, 2, 0, 0, 0))
    group = doc.add_group('Not Generic 1')
    group.add_field('ZigZag 1', 'string', 'far 4')
    group.add_field('FooBar 1', 'string', 'far 5')
    group.add_field('Moo 1', 'string', 'far 6')

    ('A'..'Z').each do |letter|
      doc = create_doc("Article #{letter}", "Sir #{letter}", Time.utc(2002, 10, 15, 0, 0, 0))
    end
  end
end
