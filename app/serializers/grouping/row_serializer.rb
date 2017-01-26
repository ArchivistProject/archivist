class Grouping::RowSerializer < ActiveModel::Serializer
  belongs_to :group

  attributes :id, :name, :type
end
