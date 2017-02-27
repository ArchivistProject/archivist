class Grouping::GroupSerializer < ActiveModel::Serializer
  attributes :id, :name
  attribute :can_edit?, key: :can_edit

  has_many :rows, key: :fields
end
