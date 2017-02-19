class DocumentStorage < MongoidBase
  belongs_to :document

  field :type, type: String

  def html?
    type == DocumentStorage::Html::TYPE
  end
end
