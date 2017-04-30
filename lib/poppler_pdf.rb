class PopplerPDF
  class << self
    def get_text(pdf_data)
      tid = SecureRandom.uuid
      temp_in = Tempfile.new([tid, '.pdf'])
      temp_out = Tempfile.new([tid, '.txt'])
      temp_in.binmode
      temp_in.write(pdf_data)
      #puts "COMMAND: pdftotext -raw #{temp_in.path} #{temp_out.path}"
      system "pdftotext -raw #{temp_in.path} #{temp_out.path}"
      if $CHILD_STATUS.exitstatus > 0
        raise 'Something went wrong with pdf to text conversion'
      end
      raw_text = temp_out.read
      return raw_text
    ensure
      temp_in.close
      temp_out.close
      temp_in.delete
      temp_out.delete
    end
  end
end
