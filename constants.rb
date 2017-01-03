module Constants
  module Error
    module Http
      SUCCESS_CALL = 0
      HTTP_FAILED = 800

      HTTP_NO_CREDENTIAL = 801
      HTTP_INVALID_CREDENTIAL = 802
      HTTP_CREDENTIAL_NOT_MATCH = 803
      HTTP_TOKEN_EXPIRED = 804
      HTTP_LOGIN_REQUIRED = 805
      HTTP_ACCESS_FORBIDDEN = 806

      HTTP_MAX = 899
    end

    module Common
      MISSING_PARAMETER = 1100001
      UNSUPPORTED_TYPE = 1100002
      DATABASE_ERROR = 1100003
    end

    module Sign
      EMAIL_FORMAT_WRONG = 1100011
      MOBILE_FORMAT_WRONG = 1100012
      MOBILE_ALREADY_USED = 1100013
      EMAIL_ALREADY_USED = 1100014
      PASSWORD_FORMAT_WRONG = 1100015
      USER_NOT_FOUND = 1100016
      PASSWORD_NOT_MATCH = 1100017
      VCODE_NOT_MATCH = 1100018
      VCODE_TYPE_WRONG = 1100019
      NICK_NAME_EXIST = 1100020
    end
  end

  ERROR_MESSAGES = {
    Error::Http::SUCCESS_CALL => 'OK',

    Error::Http::HTTP_NO_CREDENTIAL => '请求缺少身份信息',
    Error::Http::HTTP_INVALID_CREDENTIAL => '无效的请求身份',
    Error::Http::HTTP_CREDENTIAL_NOT_MATCH => '请求身份不匹配',
    Error::Http::HTTP_TOKEN_EXPIRED => 'access token已失效',
    Error::Http::HTTP_LOGIN_REQUIRED => '需要登录后才可以操作',
    Error::Http::HTTP_ACCESS_FORBIDDEN => '无权访问',

    Error::Common::MISSING_PARAMETER => '缺少参数',
    Error::Common::UNSUPPORTED_TYPE => '不支持的数据类型',
    Error::Common::DATABASE_ERROR => '数据库错误',
    Error::Sign::EMAIL_FORMAT_WRONG => '无效的邮箱格式',
    Error::Sign::MOBILE_FORMAT_WRONG => '无效的手机号码',
    Error::Sign::MOBILE_ALREADY_USED => '手机号码已被使用',
    Error::Sign::EMAIL_ALREADY_USED => '邮箱已被使用',
    Error::Sign::PASSWORD_FORMAT_WRONG => '密码格式不正确',
    Error::Sign::USER_NOT_FOUND => '用户不存在',
    Error::Sign::PASSWORD_NOT_MATCH => '用户密码不匹配',
    Error::Sign::VCODE_NOT_MATCH => '验证码不匹配',
    Error::Sign::VCODE_TYPE_WRONG => '验证码类型不匹配'
  }.freeze
end
