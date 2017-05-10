class Tag < MongoidBase
  has_and_belongs_to_many :notes
  has_and_belongs_to_many :documents

  after_initialize :update_search_name

  field :name, type: String
  field :search_name, type: String

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: true }
  #before_create do
  #  raise "Tag with id #{name} already exists" unless Tag.where(id: name).exists?
  #  self._id = name
  #end

  private

  def update_search_name
    return unless new_record?
    self.search_name ||= self.name.downcase
  end
end
