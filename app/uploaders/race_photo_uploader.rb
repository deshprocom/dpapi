class RacePhotoUploader < BaseUploader
  process resize_to_limit: [900, nil]

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    return if super.nil?

    @name ||= Digest::MD5.hexdigest(current_path)
    "#{@name}.#{file.extension.downcase}"
  end

  ALLOW_VERSION_MAPPING = {
    sm: 'iopcmd=thumbnail&type=4&width=200',
    md: 'iopcmd=thumbnail&type=4&width=500',
    lg: 'iopcmd=thumbnail&type=4&width=900'
  }.freeze
  def url(version_name = nil)
    @url ||= super({})
    return @url if version_name.blank?

    version_name = version_name.to_sym
    unless version_name.in?(ALLOW_VERSION_MAPPING)
      raise "ImageUploader version_name:#{version_name} not allow."
    end

    [@url, ALLOW_VERSION_MAPPING[version_name]].join('?')
  end
end
