class DocumentStorage < MongoidBase
  belongs_to :document

  field :type, type: String

  def html?
    self.type == DocumentStorageType::Html::TYPE
  end

end
