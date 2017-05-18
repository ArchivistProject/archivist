class Note < MongoidBase
  include Taggable

  belongs_to :document

  field :highlight_id,     type: String
  field :color,            type: String
  field :highlighted_text, type: String
  field :content,          type: String
  field :num_elems,        type: Integer
end
