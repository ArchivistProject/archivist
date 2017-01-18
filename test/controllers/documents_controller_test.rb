require 'test_helper'

class DocumentsControllerTest < ActionDispatch::IntegrationTest
  class Index < ActionDispatch::IntegrationTest
    test 'fields are sorted by groupname then fieldname' do
      doc = Document.create_new_doc
      group = doc.add_group('Not Generic 2')
      group.add_field('ZigZag 1', 'string', 'some value')
      group.add_field('FooBar 1', 'string', 'some value 2')
      group = doc.add_group('Not Generic 1')
      group.add_field('ZigZag 2', 'string', 'some value 4')
      group.add_field('FooBar 2', 'string', 'some value 5')

      get document_url(doc.id)

      assert_response :success
      fields = ActiveSupport::JSON.decode(@response.body)['document']['metadata_fields']
      expected_order = ['FooBar 2', 'ZigZag 2', 'FooBar 1', 'ZigZag 1']
      fields.zip(expected_order).each do |f, e|
        assert_equal f['name'], e
      end

      doc.revision.destroy
    end
  end
end
