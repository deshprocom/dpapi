ACCESS_TOKEN_TTL = 1.week
##
# DpAPI访问令牌
# 每次成功调用 登录 / 注册 接口, 都会为该调用生成新的访问令牌, 用于后续的接口访问时的身份识别;
# 令牌默认有效期为1周
class AppAccessToken
  # 生成jwt token
  def self.jwt_create(app_secret, user_id)
    expire_time = ACCESS_TOKEN_TTL.from_now.to_i
    payload = { user_id: user_id, exp: expire_time }
    JWT.encode payload, app_secret.to_s, 'HS256'
  end

  # 获取jwt token里面的内容
  def self.jwt_decode(app_secret, access_token)
    JWT.decode access_token, app_secret, true, algorithm: 'HS256'
  rescue
    nil
  end
end
