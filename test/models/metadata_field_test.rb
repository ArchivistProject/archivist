require 'test_helper'

class MetadataFieldTest < ActiveSupport::TestCase
  setup do
    @doc = Document.create_new_doc
    @group = @doc.add_group('Foo')
  end

  teardown do
    @doc.revision.destroy
  end

  test 'type field is automatically updated on creation' do
    field = @group.add_field('name', MetadataField::String::TYPE, 'some value')

    assert_equal field.type, MetadataField::String::TYPE
  end

  test 'must be instantiated with a type' do
    assert_raises(RuntimeError) { MetadataField.new }
  end

  test 'search can be done on both all the fields and a specific type' do
    field = @group.add_field('name', MetadataField::String::TYPE, 'some value')

    assert_nothing_raised { MetadataField.find(field.id) }
    assert_nothing_raised { MetadataField::String.find(field.id) }
    assert_raises(Mongoid::Errors::DocumentNotFound) { MetadataField::Date.find(field.id) }
  end
end
