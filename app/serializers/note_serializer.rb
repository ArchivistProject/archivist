class NoteSerializer < ActiveModel::Serializer
  attributes :id, :color, :content
end
