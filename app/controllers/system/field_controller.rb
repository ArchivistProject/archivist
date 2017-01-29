class System::FieldController < ApplicationController
  def create
    group.rows << Grouping::Row.new(params.require(:field).permit(:name, :type))
    render json: { sucess: true }
  end

  def update
    field.update_attributes(params.require(:field).permit(:name, :type))
    render json: { sucess: true }
  end

  def destroy
    field.destroy
    # NOTE: I have no clue why I have to do this (and I shouldn't have to)
    Grouping::Group.find(params[:group_id]).rows = group.rows
    render json: group
  end

  private

  def group
    @group ||= Grouping::Group.find(params[:group_id])
  end

  def field
    @field ||= group.rows.find(params[:id])
  end
end