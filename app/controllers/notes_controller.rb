class NotesController < ApplicationController
  def create
    document.notes.create! params.require(:note).permit!
  end

  def update
    note.update_attributes params.require(:note).permit!
  end

  private

  def document
    @document ||= Document.find(params[:document_id])
  end

  def note
    @note ||= Note.find(params[:id])
  end
end
