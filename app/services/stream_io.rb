module Services
  module StreamIo
    def self.write_stream_to_file(stream)
      ext = begin
        "."+MIME::Types[stream.meta["content-type"]].first.extensions.first
      rescue
        File.extname(stream.base_uri.path)
      end

      file = Tempfile.new ["temp", ext]
      begin
        file.binmode
        file.write stream.read
      ensure
        file.flush rescue nil
        file.close rescue nil
      end

      file
    end
  end
end