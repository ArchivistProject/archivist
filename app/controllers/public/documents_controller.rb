class Public::DocumentsController < ApplicationController
  include PublicAccessibleController

  skip_before_action :authenticate_request

  def create
    create_doc(params)
  end
end
