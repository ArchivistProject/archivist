class Revision < MongoidBase
  has_many :documents, dependent: :destroy

  def add_document
    doc = Document.new
    documents << doc
    doc.save!
    save!

    doc
  end
end
