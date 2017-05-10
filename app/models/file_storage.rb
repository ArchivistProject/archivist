class FileStorage < MongoidBase
  belongs_to :document

  mount_base64_uploader :file, ReadableUploader

  field :fulltext, type: String, default: ''
  index fulltext: 'text'

  delegate :content_type, :size, :read, to: :file

  def readable_size
    in_kb = size / 1000.0
    return "#{in_kb / 1000.0} MB" if inKB > 500
    "#{in_kb} KB"
  end

  def html?
    content_type == 'text/html'
  end

  def pdf?
    content_type == 'application/pdf'
  end
end
