require 'test_helper'

class DocumentsSearchControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc = []
  end

  teardown do
    @doc.each do |d|
      d.revision.destroy
    end
  end

  test 'search tags' do
    @doc = [
      create_doc(tags: %w(a)),
      create_doc(tags: %w(a d)),
      create_doc(tags: %w(d))
    ]
    query = { search: [
      s(DocumentsSearchController::TAGS, 'or', true, tags: %w(a b c))
    ] }

    post search_documents_url, params: query

    check_ids @doc[0..1]

    query = { search: [
      s(DocumentsSearchController::TAGS, 'or', true, tags: %w(a b c)),
      s(DocumentsSearchController::TAGS, 'or', true, tags: %w(d))
    ] }

    post search_documents_url, params: query

    check_ids @doc[1..1]
  end

  private

  def check_ids(docs)
    p docs
    s1 = Set.new(ActiveSupport::JSON.decode(@response.body)['documents'].map { |d| d['id'] })
    s2 = Set.new(docs.map(&:id))
    p s1
    assert_equal docs.size, (s1 & s2).size
  end

  def create_doc(tags = [])
    d = Document.create_new_doc
    d.update_tags tags
    d.save!

    d
  end

  def s(group, and_or, n, d)
    { groupType: group, andOr: and_or, not: !n }.merge d
  end
end
