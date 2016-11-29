class TagArray < MongoidBase
  belongs_to :document
  belongs_to :note

  has_many :tags
end
