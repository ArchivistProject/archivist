class Document < Mongoid_Base
  belongs_to :revision

  has_one :document_storage

  has_many :tag_arrays
  has_many :notes

  def initialize
  end
end