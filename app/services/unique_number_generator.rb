##
# 唯一编号生成器
# model              需要产生的单号的model
# key                model中被唯一的编号字段
# incr_min_length   增加量的最小长度
#
module Services
  class UniqueNumberGenerator
    include Serviceable
    attr_accessor :model, :key, :incr_min_length
    DATE_FORMAT_LENGTH = 8

    def initialize(model, key = :order_number, incr_min_length = 5)
      self.model = model
      self.key = key
      self.incr_min_length = incr_min_length
    end

    def call
      "#{today_prefix}#{padded_today_increment}"
    end

    def padded_today_increment
      today_increment.to_s.rjust(incr_min_length, '0')
    end

    def today_increment
      if Rails.cache.data.exists(today_cache_key)
        return Rails.cache.increment(today_cache_key)
      end
      set_today_increment
    end

    def set_today_increment
      if today_record_exist? # rubocop:disable Style/ConditionalAssignment
        current_increment = restore_today_increment
      else
        current_increment = Rails.cache.increment(today_cache_key)
      end
      Rails.cache.expire(today_cache_key, 1.day)
      current_increment
    end

    def restore_today_increment
      last_increment = last_record_number[DATE_FORMAT_LENGTH..-1].to_i
      Rails.cache.increment(today_cache_key, last_increment + 1)
    end

    def today_record_exist?
      last_record_number && last_record_number.first(DATE_FORMAT_LENGTH) == today_prefix
    end

    def last_record_number
      @record_number ||= model.last&.send(key)
    end

    def today_cache_key
      "#{model}::#{key}::#{today_prefix}::increment"
    end

    def today_prefix
      @today_prefix ||= Time.current.strftime('%Y%m%d')
    end
  end
end
