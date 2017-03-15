class DocumentsSearchController < ApplicationController
  include PaginationController

  def search
    p params
    params = params.permit(search: [:groupType, :andOr, :not]) #TODO finish
    p params
    render_failure if params[:search].nil? || params[:search].size == 0

    # NOTE: pretty sure sorting doesn't help at all in the current form
    # TODO: accumulate nin doc ids as to not reuse them in search?
    docs_query = params[:search].inject(Documents) do |query, c|
      case c[:groupType]
      when 'ItemTypes'
        search_item_types(query, c[:item_types], c[:andOr], c[:not])
      when 'Tags'
        search_tags(query, c[:tags], c[:andOr], c[:not])
      when 'Metadata'
        search_fields(query, c[:fields], c[:andOr], c[:not])
      when 'Description'
        query.where(description: /#{c[:description]}/)
      end
    end

    docs_to_show = docs_query.paginate(page: params[:page], per_page: 10)
    render json: docs_to_show, meta: pagination_dict(docs_to_show), root: 'documents'
  end

  private

  def search_tags(docs, tags, and_or, not)
    ds = Tag.where(:name.in => tags).pluck(:document_ids)
    if and_or == 'and'
      doc_ids = ds.inject { |i,j| Set.new(i) & Set.new(j) }.to_a # intersection
    elsif and_or == 'or' # else?
      doc_ids = ds.flatten.uniq
    end

    id = !not ? :id.in : :id.nin
    docs.where(id => doc_ids)
  end

  def search_item_types(docs, item_types, and_or, not)
    ds = MetadataGroup.where(:name.in => item_types).pluck(:document_ids)
    if and_or == 'and'
      doc_ids = ds.inject { |i,j| Set.new(i) & Set.new(j) }.to_a # intersection
    elsif and_or == 'or' # else?
      doc_ids = ds.flatten.uniq
    end

    id = !not ? :id.in : :id.nin
    docs.where(id => doc_ids)
  end

  def search_fields(docs, fields, and_or, not)
    # TODO: And really wants to start at the group first rather than the fields

    # Not getting type b/c that is in the fields sent down
    q = fields.inject(MetadataField) { |m,f| m.or(f.extract! :name, :type) }
    all_fields = q.pluck(:id, :name, :data, :metadata_group_id).map do |f|
      f[0..-2] + MetadataGroup.pluck_from(f[-1], :name, :document_id)
    end

    fields_by_name = fields.group_by { |f| f[:name] }
    matching_fields = all_fields.select do |id, name, data, group_name|
      # There should not be any duplicate group_name or 'Any' in fields_by_name[:name]
      m = fields_by_name[:name].find { |e| e[:group].in? [group_name, 'Any'] }
      next false if m.nil?
      data_matches? m[:data], data, m[:type] # return true/false
    end.compact

    if and_or == 'and'
      common_doc_ids = matching_fields.inject do |i,j|
        Set.new([i[-1]]) & Set.new([j[-1]]) # TODO: short circuit on i if it has no elements?
      end

      doc_ids = matching_fields.map { |f| f[-1] if f[-1].in? common_doc_ids }.compact
    elsif and_or == 'or'
      doc_ids = matching_fields.map { |f| f[-1] }
    end

    id = !not ? :id.in : :id.nin
    docs.where(id => doc_ids)
  end
end
