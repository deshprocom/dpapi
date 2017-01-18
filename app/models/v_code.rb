VCODE_EXPIRE_TIME = 5.minutes
class VCode
  cattr_accessor :vcode_factory

  class << self
    def generate_mobile_vcode(type, mobile)
      generate_vcode(type, mobile)
    end

    def generate_email_vcode(type, email)
      generate_vcode(type, email)
    end

    private

    def generate_vcode(type, account)
      vcode_key = vcode_cache_key(type, account)
      vcode_factory ||= ->(*args) { Random.rand(*args) }
      vcode = vcode_factory.call(100_000..999_999).to_s
      Rails.logger.info "VCode: generate vcode #{vcode} for #{type} #{account}"
      Rails.cache.write vcode_key, vcode, expires_in: VCODE_EXPIRE_TIME
      vcode
    end

    def vcode_cache_key(type, account)
      "dpapi:v10:vcode:#{type}:#{account}"
    end
  end
end