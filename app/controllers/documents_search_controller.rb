class DocumentsSearchController < ApplicationController
  include PaginationController

  def search
    p params
    docs = Document
    params = params.permit(search: [:groupType, :andOr, :not]) #TODO finish

    unless params[:item_types].nil?
      doc_ids = MetadataGroup.where(:name.in => params[:item_types]).pluck(:document_id)
      docs = docs.where(:id.in => doc_ids)
    end

    unless params[:fields].nil?
      #names = params[:fields].keys
      #values = params[:fields]
      #group_ids = []
      #MetadataField.where(:name.in => names).each do |field|
      #  group_ids << field.metadata_group_id if values[field.name] == field.value # add function for this in MetadataField to take care of the date
      #end
      f = MetadataField
      params[:fields].each { |k,v| f = f.or(name: key, data: v) }

      doc_ids = MetadataGroup.where(:id.in => f.pluck(:metadata_group_id)).pluck(:document_id)
      docs = docs.where(:id.in => doc_ids)
    end

    unless params[:tags].nil?
      doc_ids = Tag.where(:name.in => params[:tags]).pluck(:document_ids).flatten.uniq
      docs = docs.where(:id.in => doc_ids)
    end

    #This should always be last b/c it is the slowest
    unless params[:description].nil?
      docs = docs.where(description: /#{params[:description]}/)
    end

    docs_to_show = docs.paginate(page: params[:page], per_page: 10)
    render json: docs_to_show, meta: pagination_dict(docs_to_show), root: 'documents'
  end

  private

  def search_tags(docs, tags, and_or, not)
    # and true
    # Get all the docs from a single tag, then iterate over all those docs and check
    # each of those docs has all the tags.  Then docs.where(:id.in => doc_ids)

    # and false
    # same as above, except this time use the resulting doc_ids w/ docs.where(:id.nin => doc_ids)

    # or true
    # get all tags that match the given ids, then return all the documents for those
    # tags.

    # or false
    # above except w/ docs.where(:id.nin => doc_ids)

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
    # this is the exact same as tags
  end

  def search_fields(docs, fields, and_or, not)
    # TODO: And really wants to start at the group first rather than the fields

    # Not getting type b/c that is in the fields sent down
    all_fields = MetadataField.where(:name.in => fields.maps(&:name)).pluck(:id, :name, :data, :metadata_group_id)
    all_fields.map! { |f| f[0..-2] + MetadataGroup.pluck_from(f[-1], :name, :document_id) }

    fields_by_name = fields.group_by { |f| f[:name] }
    matching_fields = all_fields.select do |id, name, data, group_name|
      # There should not be any duplicate group_name or 'Any' in fields_by_name[:name]
      m = fields_by_name[:name].find { |e| e[:group].in? [group_name, 'Any'] }
      data_matches? m[:data], data, m[:type] # return true/false
    end

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
