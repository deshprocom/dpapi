class RefundUploader < BaseUploader
  def store_dir
    "uploads/refund/#{mounted_as}/#{model.id}"
  end

  def filename
    return if super.nil?

    @md5_name ||= Digest::MD5.hexdigest(current_path)
    "#{@md5_name}.#{file.extension.downcase}"
  end
end