class HejiaPublishChannel < ActiveRecord::Base
  self.table_name = "HEJIA_PUBLISH_CHANNEL"
  acts_as_readonlyable [:read_only_51hejia]
end
