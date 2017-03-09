class Setting < MongoidBase
  field :docs_per_page, type: Integer, default: 10

  validates :docs_per_page, numericality: { only_integer: true, greater_than: 0 }

  def self.global
    return Setting.all.first if Setting.all.size == 1
    raise 'Something went wrong with the Setting model' if Setting.all.size > 1

    Setting.create!
  end
end