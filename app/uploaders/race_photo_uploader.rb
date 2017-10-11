class RacePhotoUploader < BaseUploader
  process resize_to_limit: [900, nil]

  def store_dir
    "uploads/race/#{mounted_as}/#{model.id}"
  end

  def filename
    return if super.nil?

    @md5_name ||= Digest::MD5.hexdigest(current_path)
    "#{@md5_name}.#{file.extension.downcase}"
  end

  # 在 UpYun 配置图片缩略图
  # http://docs.upyun.com/guide/#_12
  # 固定宽度,高度自适应
  # xs - 100
  # sm - 200
  # md - 500
  # lg - 1080

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
