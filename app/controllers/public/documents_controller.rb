class Public::DocumentsController < ApplicationController
  include PublicAccessibleController

  def create
    create_doc(params)
  end
end
