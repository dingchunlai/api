gem 'memcache-client'
require 'memcache'

memcache_options = {
  :ttl => 1,
  :compression => false,
  :debug => false,
  :namespace => "publish-#{RAILS_ENV}",
  :readonly => false,
  :urlencode => false
}

memcache_z_options = {
  :ttl => 1,
  :compression => false,
  :debug => false,
  :namespace => "zhuangxiu-#{RAILS_ENV}",
  :readonly => false,
  :urlencode => false
}

publish_memcache_options = {
  :ttl => 1,
  :compression => false,
  :debug => false,
  :namespace => "publish-#{RAILS_ENV}",
  :readonly => false,
  :urlencode => false
}

memcache_servers = [ 'memcachehost:11211' ]
memcache_z_servers = [ 'memcachehost:11211' ]

cache_params = *([memcache_servers, memcache_options].flatten)
CACHE = MemCache.new *cache_params

cache_z_params = *([memcache_z_servers, memcache_z_options].flatten)
CACHEZ = MemCache.new *cache_z_params

publish_params = *([memcache_servers, publish_memcache_options].flatten)
PUBLISH_CACHE = MemCache.new *publish_params
