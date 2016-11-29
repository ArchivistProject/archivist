class Tag < MongoidBase
  belongs_to :tag_array

  field :name, type: String
end
