##
# 唯一单号生成器
# key    model中被唯一的编号字段
#
module NumberGenerator
  extend ActiveSupport::Concern
  # 类方法
  module ClassMethods
    cattr_accessor :number_factory

    def unique_number(key = :order_number)
      max_tries = 10
      max_tries.times do
        value = random_number_with_prefix
        return value unless exists?(key => value)
      end
      Rails.logger.error("#{self}:Generate #{key} fail (tried #{max_tries} times)")
      nil
    end

    def random_number_with_prefix
      prefix = Time.current.strftime('%Y%m%d')
      "#{prefix}#{random_number}"
    end

    def random_number
      self.number_factory ||= -> { Random.rand(10_000...99_999) }
      number_factory.call
    end
  end
end
