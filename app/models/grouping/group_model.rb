class Grouping::Group < MongoidBase
  embeds_many :rows

  field :name, type: String

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validate do
    row_names = rows.each { |r| r.name.downcase }
    unless row_names.size == row_names.to_set.size
      errors.add(:rows, 'All row names must be unique in a group')
    end
  end
end
