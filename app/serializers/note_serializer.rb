class NoteSerializer < ActiveModel::Serializer
  attributes :id, :color
  attribute :highlight_id, key: :highlightId
  attribute :highlighted_text, key: :text
  attribute :content, key: :note
  attribute :num_elems, key: :numElements
  attribute :start_pos, key: :startPos
end
