module PublicAccessibleController
  extend ActiveSupport::Concern

  def show_all_groups
    render json: Grouping::Group.all, root: 'groups'
  end

  def create_doc(params)
    attrs = params.require(:document).permit(:file, tags: [], metadata_fields: [:name, :type, :data, :group])
    doc = Document.create_new_doc

    #FORMAT: data:application/pdf;base64,(%s)
    #        where %s is the base64 encoded file
    doc.add_storage attrs[:file]

    doc.update_tags(attrs[:tags].nil? ? [] : attrs[:tags])

    groups = attrs[:metadata_fields].group_by { |g| g[:group] }
    groups.each do |group_name, fields|
      group = doc.add_group(group_name)
      fields.each { |f| group.add_field(f[:name], f[:type], f[:data]) }
    end

    render_success
  end
end
