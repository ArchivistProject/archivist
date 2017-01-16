class DocumentStorage < MongoidBase
  belongs_to :document

  field :type, type: String

  def html?
    type == DocumentStorageType::Html::TYPE
  end
end
