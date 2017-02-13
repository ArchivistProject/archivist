class Tag < MongoidBase
  has_and_belongs_to_many :notes
  has_and_belongs_to_many :documents

  field :name, type: String

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  #before_create do
  #  raise "Tag with id #{name} already exists" unless Tag.where(id: name).exists?
  #  self._id = name
  #end
end
