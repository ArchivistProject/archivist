class Grouping::GroupSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :rows, key: :fields
end
