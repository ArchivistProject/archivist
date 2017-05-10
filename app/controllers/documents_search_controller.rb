class DocumentsSearchController < ApplicationController
  TAGS = 'Tags'.freeze
  ITEM_TYPES = 'ItemTypes'.freeze
  METADATA = 'Metadata'.freeze
  DESCRIPTION = 'Description'.freeze
  FULLTEXT = 'FullText'.freeze
  include PaginationController
  include SortController

  def search
    attrs = params.permit(
      :page,
      search: [
        :andOr,
        groups: [
          :groupType, :andOr, :not,
          :description,
          :terms,
          fields: [:data, :group, :name, :type],
          tags: [],
          item_types: []
        ]
      ]
    )
    return render_failure if attrs[:search].nil? || attrs[:search][:groups].nil? || !attrs[:search][:andOr].in?(%w(and or))

    s = Setting.global

    docs_query = build_query attrs[:search]
    logger.debug docs_query

    docs_to_show = order(docs_query).paginate(page: attrs[:page], per_page: s.docs_per_page)
    render json: docs_to_show, meta: pagination_dict(docs_to_show), root: 'documents'
  end

  private

  def build_query(attrs)
    # NOTE: pretty sure sorting doesn't help at all in the current form
    # TODO: accumulate nin doc ids as to not reuse them in search?
    attrs[:groups].inject(Document) do |query, c|
      case c[:groupType]
      when ITEM_TYPES
        doc_ids = search_item_types(c[:item_types], c[:andOr])
        query.public_send(attrs[:andOr], id(c[:not]) => doc_ids)
      when TAGS
        doc_ids = search_tags(c[:tags], c[:andOr])
        query.public_send(attrs[:andOr], id(c[:not]) => doc_ids)
      when METADATA
        doc_ids = search_fields(c[:fields], c[:andOr])
        query.public_send(attrs[:andOr], id(c[:not]) => doc_ids)
      when DESCRIPTION
        query.public_send(attrs[:andOr], description: /#{c[:description]}/)
      when FULLTEXT
        #collection = Mongoid::Clients.default[:mongoid_bases]
        #docs_by_score = collection.find("$text": { "$search": "house" }).projection(score: { "$meta": "textScore" }, document_id: 1).sort(score: { '$meta': 'textScore' })
        doc_ids = FileStorage.text_search(c[:terms]).pluck(:document_id) #TODO: Move FileStorage into the document?
        query.public_send(attrs[:andOr], id(c[:not]) => doc_ids)
      else
        raise 'Unknown search field'
      end
    end
  end

  def search_tags(tags, and_or)
    little_tags = tags.map { |t| t.downcase }
    ds = Tag.where(:search_name.in => little_tags).pluck(:document_ids)
    if and_or == 'and'
      doc_ids = ds.inject { |a, e| Set.new(a) & Set.new(e) }.to_a # intersection
    elsif and_or == 'or' # else?
      doc_ids = ds.flatten.uniq
    end

    doc_ids
  end

  def search_item_types(item_types, and_or)
    ds = MetadataGroup.where(:name.in => item_types).pluck(:document_id)
    if and_or == 'and'
      doc_ids = ds.group_by { |v| v }.map do |document_id, groups|
        # Skip if document doesn't have all the groups
        next nil if groups.size != item_types.size
        document_id
      end.compact
    elsif and_or == 'or' # else?
      doc_ids = ds.flatten.uniq
    end

    doc_ids
  end

  def search_fields(fields, and_or)
    # TODO: And really wants to start at the group first rather than the fields

    # Not getting type b/c that is in the fields sent down
    q = fields.inject(MetadataField) { |a, e| a.or(e.slice(:name, :type)) }
    all_fields = q.pluck(:id, :name, :data, :metadata_group_id).map do |f|
      # TODO: either include the document id in the metadata field, or massify this query
      f[0..-2] + MetadataGroup.pluck_from(f[-1], :name, :document_id)
    end

    fields_by_name = fields.group_by { |f| f[:name] }
    matching_fields = all_fields.select do |_, name, data, group_name|
      # There should not be any duplicate group_name or 'Any' in fields_by_name[:name]
      m = fields_by_name[name].find { |e| e[:group].in? [group_name, 'Any'] }
      next false if m.nil?
      MetadataField.data_matches? m[:data], data, m[:type] # return true/false
    end.compact

    if and_or == 'and'
      doc_ids = matching_fields.group_by { |v| v[-1] }.map do |document_id, f|
        # Skip if document doesn't have all the fields
        next nil if f.size != fields.size
        document_id
      end.compact
    elsif and_or == 'or'
      doc_ids = matching_fields.map { |f| f[-1] }
    end

    doc_ids
  end

  def id(inverse)
    return :id.in if inverse == 'false' || inverse == false
    :id.nin
  end
end
