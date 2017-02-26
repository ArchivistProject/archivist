class Public::GroupsController < ApplicationController
  include PublicAccessibleController

  def index
    show_all_groups
  end
end
