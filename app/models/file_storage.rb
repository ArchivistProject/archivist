class FileStorage < MongoidBase
  belongs_to :document

  mount_base64_uploader :file, ReadableUploader

  def content_type
    file.content_type
  end

  def size
    file.size
  end

  def read
    file.read
  end

  def html?
    content_type == 'text/html'
  end

  def pdf?
    content_type == 'application/pdf'
  end
end
