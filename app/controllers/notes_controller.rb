class NotesController < ApplicationController
  def create
    n = params.require(:note).permit(
      :highlighter,
      :highlightId,
      :text,
      :note
    )
    document.update_attributes n.permit(:highlighter)
    document.notes.create!(
      highlight_id: n[:highlightId],
      highlighted_text: n[:text],
      content: n[:note]
    )
    render json: { id: Note.where(highlight_id: n[:highlightId]).pluck(:id) }
  end

  def update
    n = params.require(:note).permit(
      :highlightId,
      :text,
      :note
    )
    note.update_attribute :highlight_id, n[:highlightId] unless n[:highlightId].nil?
    note.update_attribute :highlighted_text, n[:highlighted_text] unless n[:highlighted_text].nil?
    note.update_attribute :content, n[:note] unless n[:note].nil?
  end

  def destroy
    n = params.require(:note).permit(
      :highlighter,
      :highlightId
    )

    document.update_attributes n.permit(:highlighter)
    document.notes.find_by(highlight_id: n[:highlightId]).destroy
  end

  private

  def document
    @document ||= Document.find(params[:document_id])
  end

  def note
    @note ||= Note.find(params[:id])
  end
end
