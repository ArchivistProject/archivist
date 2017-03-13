class Public::DocumentsController < ApplicationController
  include PublicAccessibleController
  
  skip_before_action :authenticate_request
  before_action :authenticate_api_key

  def create
    create_doc(params)
  end
end
