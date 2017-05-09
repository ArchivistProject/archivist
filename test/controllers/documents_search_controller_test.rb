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

  test 'tags with single query "or"/"and" behave the same' do
    @doc = [
      create_doc(tags: %w(a)),
      create_doc(tags: %w(a d)),
      create_doc(tags: %w(d))
    ]

    make_post(search: {
      andOr: 'and',
      groups: [
        s(DocumentsSearchController::TAGS, 'or', true, tags: %w(a))
      ]
    }, matches: @doc[0..1])

    make_post(search: {
      andOr: 'and',
      groups: [
        s(DocumentsSearchController::TAGS, 'or', false, tags: %w(a))
      ]
    }, matches: @doc[2..2])

    make_post(search: {
      andOr: 'and',
      groups: [
        s(DocumentsSearchController::TAGS, 'and', true, tags: %w(a))
      ]
    }, matches: @doc[0..1])

    make_post(search: {
      andOr: 'and',
      groups: [
        s(DocumentsSearchController::TAGS, 'and', false, tags: %w(a))
      ]
    }, matches: @doc[2..2])
  end

  test 'search tags with "or" and "true"/"false"' do
    @doc = [
      create_doc(tags: %w(a)),
      create_doc(tags: %w(a d)),
      create_doc(tags: %w(d))
    ]

    make_post(search: {
      andOr: 'and',
      groups: [
        s(DocumentsSearchController::TAGS, 'or', true, tags: %w(a b c))
      ]
    }, matches: @doc[0..1])

    make_post(search: {
      andOr: 'and',
      groups: [
        s(DocumentsSearchController::TAGS, 'or', false, tags: %w(a b c))
      ]
    }, matches: @doc[2..2])

    make_post(search: {
      andOr: 'and',
      groups: [
        s(DocumentsSearchController::TAGS, 'or', true, tags: %w(a b c)),
        s(DocumentsSearchController::TAGS, 'or', true, tags: %w(d))
      ]
    }, matches: @doc[1..1])

    make_post(search: {
      andOr: 'and',
      groups: [
        s(DocumentsSearchController::TAGS, 'or', false, tags: %w(a b c)),
        s(DocumentsSearchController::TAGS, 'or', true, tags: %w(a d))
      ]
    }, matches: @doc[2..2])

    make_post(search: {
      andOr: 'and',
      groups: [
        s(DocumentsSearchController::TAGS, 'or', false, tags: %w(a)),
        s(DocumentsSearchController::TAGS, 'or', false, tags: %w(d))
      ]
    }, matches: [])
  end

  test 'search tags with "and" and "true"/"false"' do
    @doc = [
      create_doc(tags: %w(a c d)),
      create_doc(tags: %w(a d)),
      create_doc(tags: %w(d))
    ]

    make_post(search: {
      andOr: 'and',
      groups: [
        s(DocumentsSearchController::TAGS, 'and', true, tags: %w(a d))
      ]
    }, matches: @doc[0..1])

    make_post(search: {
      andOr: 'and',
      groups: [
        s(DocumentsSearchController::TAGS, 'and', false, tags: %w(a d))
      ]
    }, matches: @doc[2..2])
  end

  private

  def make_post(search: se, matches: m)
    post search_documents_url, params: { search: search }, headers: http_login
    check_ids matches
  end

  def check_ids(docs)
    #p ActiveSupport::JSON.decode(@response.body)
    s1 = Set.new(ActiveSupport::JSON.decode(@response.body)['documents'].map { |d| d['id'] })
    s2 = Set.new(docs.map(&:id))
    #p '=====>', s1, s2
    assert_equal s2, s1
  end

  def create_doc(tags: [])
    #p tags
    d = Document.create_new_doc
    d.update_tags tags
    d.save!

    d
  end

  def s(group, and_or, n, d)
    { groupType: group, andOr: and_or, not: !n }.merge d
  end
end
