class Tag < Mongoid_Base
  belongs_to :tag_array

  field :name, type: String
end