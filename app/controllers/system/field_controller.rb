class System::FieldController < ApplicationController
  def create
    return render_failure unless group.can_edit?
    group.rows << Grouping::Row.new(params.require(:field).permit(:name, :type))
    render_success
  end

  def update
    return render_failure unless group.can_edit?
    field.update_attributes(params.require(:field).permit(:name, :type))
    render_success
  end

  def destroy
    return render_failure unless group.can_edit?
    field.destroy
    # NOTE: I have no clue why I have to do this (and I shouldn't have to)
    Grouping::Group.find(params[:group_id]).rows = group.rows
    render_success
  end

  private

  def group
    @group ||= Grouping::Group.find(params[:group_id])
  end

  def field
    @field ||= group.rows.find(params[:id])
  end
end
