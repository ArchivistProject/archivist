class DocumentStorage < MongoidBase
  belongs_to :document

  field :type, type: String

  def read

  end

  def write

  end

  def search_content(target)

  end
end