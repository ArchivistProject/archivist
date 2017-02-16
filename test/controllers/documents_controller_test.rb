require 'test_helper'

class DocumentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc = Document.create_new_doc
    group = @doc.add_group(MetadataGroup::GENERIC)
    group.add_field('Default1', MetadataField::String::TYPE, 'some value')
    group.add_field('Default2', MetadataField::String::TYPE, 'some value 2')
    @doc.save!
  end

  teardown do
    @doc.revision.destroy
  end

  test 'fields are sorted by groupname then fieldname' do
    group = @doc.add_group('A Not Generic 2')
    group.add_field('ZigZag 1', 'string', 'some value')
    group.add_field('FooBar 1', 'string', 'some value 2')
    group = @doc.add_group('A Not Generic 1')
    group.add_field('ZigZag 2', 'string', 'some value 4')
    group.add_field('FooBar 2', 'string', 'some value 5')

    get document_url(@doc.id)

    assert_response :success
    fields = ActiveSupport::JSON.decode(@response.body)['document']['metadata_fields']
    expected_order = ['Default1', 'Default2', 'FooBar 2', 'ZigZag 2', 'FooBar 1', 'ZigZag 1']
    fields.zip(expected_order).each do |f, e|
      assert_equal f['name'], e
    end
  end

  test 'tags are added and deleted' do
    %w(foo bar bing bang).each { |t| Tag.where(name: t).destroy }

    put tags_document_url(@doc.id), params: { document: { tags: %w(bar foo), count: 2 } }

    assert_response :success
    assert_equal %w(bar foo), Document.find(@doc.id).tag_names.sort

    put tags_document_url(@doc.id), params: { document: { tags: %w(bar bing), count: 2 } }

    assert_response :success
    assert_equal %w(bar bing), Document.find(@doc.id).tag_names.sort
  end

  test 'send empty array to tags' do
    put tags_document_url(@doc.id), params: { document: { tags: [], count: 0 } }

    assert_response :success
    assert_equal [], Document.find(@doc.id).tag_names
  end
end
