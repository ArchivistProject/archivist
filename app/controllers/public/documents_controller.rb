class Public::DocumentsController < ApplicationController
  def create
    doc = Document.create_new_doc

    group = doc.add_group(MetadataGroup::GENERIC)
    fields = [[:Title, 'string'], [:Author, 'string'], [:Date_Added, 'date']]
    fields.each do |name, type|
      data = type != 'date' ? params[name] : DateTime.now.utc
      group.add_field(name.to_s.sub('_', ' '), type, data)
    end

    render json: { success: true }
  end
end
