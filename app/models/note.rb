class Note < Mongoid_Base
  belongs_to :document

  has_many :tag_arrays

  field :color, type: String
  field :content, type: String
end