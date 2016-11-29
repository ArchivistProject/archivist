class Document < MongoidBase
  belongs_to :revision

  has_one :document_storage
  has_one :tag_array

  has_many :notes
  has_many :metadata_groupings

  def initialize
  end
end
