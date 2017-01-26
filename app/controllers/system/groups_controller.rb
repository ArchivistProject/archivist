class System::GroupsController < ApplicationController
  def index
    render json: Grouping::Group.all, root: 'groups'
  end

  def show
    render json: group, root: 'group'
  end

  def create
    g = Grouping::Group.new(params.require(:group).permit(:name))
    params.require(:group).permit(:fields).each do |r|
      g.rows << Grouping::Row.new(params.require(:name, :type))
    end
    g.save!
    render json: g, root: 'group'
  end

  def update
    group.name = params[:name]
    group.save!
    render json: { success: true }
  end

  def destroy
    group.destroy
    render json: { success: true }
  end

  private

  def group
    @group ||= Grouping::Group.find(params[:id])
  end
end
