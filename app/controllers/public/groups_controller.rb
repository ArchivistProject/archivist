class Public::GroupsController < ApplicationController
  include PublicAccessibleController
  
  skip_before_action :authenticate_request
  before_action :authenticate_api_key

  def index
    show_all_groups
  end
end
