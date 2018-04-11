Geocoder.configure(
    timeout: 5,
    lookup: :baidu,
    ip_lookup: :baidu_ip,
    use_https: true,
    api_key: ENV['BAIDU_API_KEY'],
    cache: Redis.new,
    cache_prefix: 'desh_baidu:',
    :units => :km,
)
