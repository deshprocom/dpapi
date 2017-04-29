class BaseUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  include CarrierWave::MiniMagick

  storage :file
  process resize_to_limit: [900, nil]
  # process :optimize

  def store_dir
    "uploads/#{model.class.to_s.underscore}"
  end

  def extension_white_list
    %w(jpg jpeg gif png svg)
  end
end
