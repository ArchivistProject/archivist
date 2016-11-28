class TagArray < Mongoid_Base
  belongs_to :document
  belongs_to :note

  has_many :tags
end