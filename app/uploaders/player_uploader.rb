class PlayerUploader < BaseUploader
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :large do
    resize_to_limit(600, 600)
  end

  version :thumb do
    process :crop
    resize_to_fill(100, 100)
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def filename
    "#{secure_token(10)}.#{file.extension}" if original_filename.present?
  end

  # rubocop:disable Style/GuardClause
  def crop
    if model.crop_x.present?
      manipulate! do |img|
        x = model.crop_x.to_s
        y = model.crop_y.to_s
        w = model.crop_w.to_s
        h = model.crop_h.to_s
        size = w << 'x' << h
        offset = '+' << x << '+' << y
        img.crop("#{size}#{offset}")
        img
      end
    end
  end

  protected

  def secure_token(length = 16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.hex(length / 2))
  end
end