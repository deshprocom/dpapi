# 电子邮箱的格式有效性验证器
module EmailValidator

  # 不支持的邮箱
  EMAIL_INVALID_FORMAT_REGEX = /^.*@(dfgggg.org|mailadadad.org|asdfooff.org|alfamailr.org|akmaila.org|rertimail.org|emailll.org|mannbdinfo.org|asdjmail.org|aspotgmail.org|askddoor.org|drthedf.org|mailfnmng.org|emailrtg.org|sdfgsdrfgf.org|dvdjapanesehome.com|suiyoutalkblog.com|tokkabanshop.com|guidejpshop.com|shopjpguide.com|newsgolfjapan.com|newsdvdjapan.com|retrt.org|blogshoponline.com|newsonlinejp.com|sportsjapanesehome.com|janewsonline.com|sportsinjapan.com|newsforhouse.com|dvdnewsonline.com|golfnewsonlinejp.com|newsinhouse.com|newssportsjapan.com|yandex.com)$/

  # 有效邮箱格式
  EMAIL_VALID_FORMAT_REGEX = /^[A-Za-z0-9]+([\_\w]*[.]?[\_\w]*[A-Za-z0-9]+)*@([A-Za-z0-9]+[\-\.])+(?!ru$|pl$)[A-Za-z0-9]{2,5}$/

  extend ActiveSupport::Concern

  module ClassMethods
    def email_valid?(email)
      if email =~ EmailValidator::EMAIL_INVALID_FORMAT_REGEX or email !~ EmailValidator::EMAIL_VALID_FORMAT_REGEX
        false
      else
        true
      end
    end
  end
end