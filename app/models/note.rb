class Note < MongoidBase
  include Taggable

  belongs_to :document

  field :color, type: String
  field :content, type: String
end
