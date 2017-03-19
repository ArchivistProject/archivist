class Public::GroupsController < ApplicationController
  include PublicAccessibleController
  skip_before_action :authenticate_request

  def index
    show_all_groups
  end
end
