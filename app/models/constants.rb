module Constants
  #Http错误
  module HttpErrorCode
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

  module CommonErrorCode
    MISSING_PARAMETER  = 1100001
    UNSUPPORTED_TYPE = 1100002
    DATABASE_ERROR = 1100003
  end

  #登录注册模块错误
  module SignErrorCode
    EMAIL_FORMAT_WRONG = 1100011
    MOBILE_FORMAT_WRONG = 1100012
    MOBILE_ALREADY_USED = 1100013
    EMAIL_ALREADY_USED = 1100014
    PASSWORD_FORMAT_WRONG = 1100015
    USER_NOT_FOUND = 1100016
    PASSWORD_NOT_MATCH = 1100017
    VCODE_NOT_MATCH = 1100018
  end


  ERROR_MESSAGES = {
      HttpErrorCode::SUCCESS_CALL => 'OK',

      HttpErrorCode::HTTP_NO_CREDENTIAL => '请求缺少身份信息',
      HttpErrorCode::HTTP_INVALID_CREDENTIAL => '无效的请求身份',
      HttpErrorCode::HTTP_CREDENTIAL_NOT_MATCH => '请求身份不匹配',
      HttpErrorCode::HTTP_TOKEN_EXPIRED => 'access token已失效',
      HttpErrorCode::HTTP_LOGIN_REQUIRED => '需要登录后才可以操作',
      HttpErrorCode::HTTP_ACCESS_FORBIDDEN => '无权访问',

      CommonErrorCode::MISSING_PARAMETER => '缺少参数',
      CommonErrorCode::UNSUPPORTED_TYPE => '不支持的数据类型',
      CommonErrorCode::DATABASE_ERROR => '数据库错误',
      SignErrorCode::EMAIL_FORMAT_WRONG => '无效的邮箱格式',
      SignErrorCode::MOBILE_FORMAT_WRONG => '无效的手机号码',
      SignErrorCode::MOBILE_ALREADY_USED => '手机号码已被使用',
      SignErrorCode::EMAIL_ALREADY_USED => '邮箱已被使用',
      SignErrorCode::PASSWORD_FORMAT_WRONG => '密码格式不正确',
      SignErrorCode::USER_NOT_FOUND => '用户不存在',
      SignErrorCode::PASSWORD_NOT_MATCH => '用户密码不匹配',
      SignErrorCode::VCODE_NOT_MATCH => '验证码不匹配'

  }
end