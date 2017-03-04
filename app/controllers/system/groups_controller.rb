class System::GroupsController < ApplicationController
  include PublicAccessibleController

  def index
    show_all_groups
  end

  def show
    render json: group
  end

  def create
    g = Grouping::Group.new(params.require(:group).permit(:name))
    g.save!
    render json: g
  end

  def update
    return render_failure unless group.can_edit?
    group.name = params[:name]
    group.save!
    render_success
  end

  def destroy
    return render_failure unless group.can_edit?
    group.destroy
    render_success
  end

  private

  def group
    @group ||= Grouping::Group.find(params[:id])
  end
end
