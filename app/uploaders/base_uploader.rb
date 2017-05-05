class BaseUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}"
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
