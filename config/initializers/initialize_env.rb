jpush_vars = %w(JPUSH_APP_KEY JPUSH_MASTER_SECRET JPUSH_APNS_PRODUCTION)
upyun_vars = %w(UPYUN_USERNAME UPYUN_PASSWD UPYUN_BUCKET UPYUN_BUCKET_HOST)
cache_vars = %w(CACHE_DATABASE_TYPE CACHE_DATABASE_PATH CACHE_RESQUE_PATH)
env_vars = %w(CURRENT_PROJECT_ENV) + jpush_vars + upyun_vars + cache_vars
env_vars.each do |var|
  if ENV[var].nil?
    raise "环境变量 #{var} 必须存在"
  end
end