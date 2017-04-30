class FileStorage < MongoidBase
  belongs_to :document

  mount_base64_uploader :file, ReadableUploader

  field :fulltext, type: String, default: ''
  index fulltext: 'text'

  delegate :content_type, :size, :read, to: :file

  def html?
    content_type == 'text/html'
  end

  def pdf?
    content_type == 'application/pdf'
  end
end
