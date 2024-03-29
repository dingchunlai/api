# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

#require 'hodel_3000_compliant_logger'
#config.logger = Hodel3000CompliantLogger.new(config.log_path, 3, 500 * 1024 * 1024) # 500M per log
#config.logger = Hodel3000CompliantLogger.new(config.log_path, 'daily') # 500M per log
#config.logger.level = Logger::DEBUG

config.logger.level = 'info'

SERVER_ID = "192.168.1.13"
begin
  require 'redis'
  REDIS_DB = Redis.new :host => SERVER_ID
  $redis = REDIS_DB
rescue 
  puts "Notice: Redis is not enabled!"
end

IS_PRODUCT = 1

if defined?(Thin)
  Thin::Logging.trace = true
  Thin::Logging.debug = true
  Thin::Logging.silent = false
end

require RAILS_ROOT + '/config/load_gems'
