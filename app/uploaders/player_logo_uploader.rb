class PlayerLogoUploader < BaseUploader
  def store_dir
    "uploads/players/#{mounted_as}/#{model.id}"
  end

  def filename
    return if super.nil?

    @md5_name ||= Digest::MD5.hexdigest(current_path)
    "#{@md5_name}.#{file.extension.downcase}"
  end

  ALLOW_VERSIONS = %w(xs sm md lg).freeze
  def url(version_name = nil)
    @url ||= super({})
    return @url if version_name.blank?

    version_name = version_name.to_s
    unless version_name.in?(ALLOW_VERSIONS)
      raise "ImageUploader version_name:#{version_name} not allow."
    end

    [@url, version_name].join('!')
  end
end