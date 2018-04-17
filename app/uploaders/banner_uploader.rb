class BannerUploader < BaseUploader
  process resize_to_limit: [1080, nil]

  def filename
    return if super.nil?

    @md5_name ||= Digest::MD5.hexdigest(current_path)
    "#{@md5_name}.#{file.extension.downcase}"
  end
end
