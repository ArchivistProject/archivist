class DocumentsSearchController < ApplicationController
  TAGS = 'Tags'.freeze
  ITEM_TYPES = 'ItemTypes'.freeze
  METADATA = 'Metadata'.freeze
  DESCRIPTION = 'Description'.freeze
  include PaginationController

  def search
    attrs = params.permit(
      :page,
      search: [
        :groupType, :andOr, :not,
        :description,
        fields: [:data, :group, :name, :type],
        tags: [],
        item_types: []
      ]
    )
    return render_failure if attrs[:search].nil?

    docs_query = build_query attrs
    logger.debug docs_query
    
    docs_to_show = docs_query.paginate(page: attrs[:page], per_page: 10)
    render json: docs_to_show, meta: pagination_dict(docs_to_show)
  end

  private

  def build_query(attrs)
    # NOTE: pretty sure sorting doesn't help at all in the current form
    # TODO: accumulate nin doc ids as to not reuse them in search?
    attrs[:search].inject(Document) do |query, c|
      case c[:groupType]
      when ITEM_TYPES
        doc_ids = search_item_types(c[:item_types], c[:andOr])
        query.and(id(c[:not]) => doc_ids)
      when TAGS
        doc_ids = search_tags(c[:tags], c[:andOr])
        query.and(id(c[:not]) => doc_ids)
      when METADATA
        doc_ids = search_fields(c[:fields], c[:andOr])
        query.and(id(c[:not]) => doc_ids)
      when DESCRIPTION
        query.and(description: /#{c[:description]}/)
      else
        raise 'horrible error!'
      end
    end
  end

  def search_tags(tags, and_or)
    ds = Tag.where(:name.in => tags).pluck(:document_ids)
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
      common_doc_ids = matching_fields.inject do |i, j|
        Set.new([i[-1]]) & Set.new([j[-1]]) # TODO: short circuit on i if it has no elements?
      end

      doc_ids = matching_fields.map { |f| f[-1] if f[-1].in? common_doc_ids }.compact
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
