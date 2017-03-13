class NotesController < ApplicationController
  include AclController

  before_action only: [:update, :update] { |c| verify(document, :be_edited?) }

  def create
    document.notes.create! params.require(:note).permit(:content, :color)
    render_success
  end

  def update
    note.update_attributes params.require(:note).permit(:content, :color)
    render_success
  end

  private

  def document
    @document ||= Document.find(params[:document_id])
  end

  def note
    @note ||= Note.find(params[:id])
  end
end
