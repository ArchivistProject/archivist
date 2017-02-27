module PublicAccessibleController
  extend ActiveSupport::Concern

  def show_all_groups
    render json: Grouping::Group.all, root: 'groups'
  end

  def create_doc(params)
    attrs = params.require(:document).permit(:file, tags: [], metadata_fields: [:name, :type, :data, :group])
    doc = Document.create_new_doc

    #FORMAT: data:application/pdf;base64,%s
    doc.add_storage attrs[:file]

    doc.update_tags(attrs[:tags].nil? ? [] : attrs[:tags])

    attrs[:metadata_fields].group_by { |g| g[:group] }.each do |group_name, fields|
      group = doc.add_group(group_name)
      field_names = fields.collect do |f|
        group.add_field(f[:name], f[:type], f[:data])
        f[:name]
      end
      Grouping::Group.find_by(name: group_name).rows.each do |r|
        group.add_field(r.name, r.type, nil) unless r.name.in? field_names
      end
    end

    render_success
  end
end
