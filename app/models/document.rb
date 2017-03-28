class Document < MongoidBase
  include Taggable

  belongs_to :revision

  has_one :file_storage, autobuild: true
  has_many :notes
  has_many :metadata_groups, dependent: :destroy do
    def generic
      find_by(name: MetadataGroup::GENERIC)
    end
  end

  field :description, type: String, default: ''

  def add_group(name)
    group = MetadataGroup.new
    group.name = name

    metadata_groups << group

    group
  end

  def add_storage(data)
    raise 'Data is already stored' unless file_storage.read.nil?

    file_storage.file = data
    if file_storage.pdf?
      reader = PDF::Reader.new(StringIO.new(file_storage.read))
      text = reader.pages.inject("") { |a,e| a + e.text }
      #text = ""
      #reader.pages.each do |page|
      #  p page.text
      #end
    elsif file_storage.html?
      html = file_storage.read
      text = Sanitize.fragment(html, :remove_contents => ['style'])
    end
    t = text.split("\n").map(&:strip).collect do |line|
      p line
      p line.split(/\W+/)
      line.split(/\W+/).join(" ")
    end.select { |f| f != "" }.join("\n")
    #puts t
    file_storage.fulltext = t

    file_storage.save!
    save!
  end

  def self.create_new_doc
    rev = Revision.new
    doc = rev.add_document

    doc
  end
end
