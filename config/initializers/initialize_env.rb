jpush_vars = %w(JPUSH_APP_KEY JPUSH_MASTER_SECRET JPUSH_APNS_PRODUCTION)
env_vars = %w(CACHE_DATABASE_TYPE CACHE_DATABASE_PATH CACHE_RESQUE_PATH
              UCLOUD_BUCKET UCLOUD_BUCKET_HOST UCLOUD_CDN_HOST CURRENT_PROJECT_ENV) + jpush_vars
env_vars.each do |var|
  if ENV[var].nil?
    raise "环境变量 #{var} 必须存在"
  end
end