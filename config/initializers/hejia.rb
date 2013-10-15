gem 'hejia_ext_links', '~> 0.7.12'
require "hejia"

Hejia.configuration.set :cache => CACHE,
                        :compatible_with_0_1_2 => true,
                        :user_model => 'hejia_user_bbs',
                        :staff_model => 'radmin_user'

Hejia.rails_init

ActionController::Base.session_options[:memcache_server] = 'memcachehost:11211' if %w[development staging].include?(RAILS_ENV)
