class HejiaEditor < ActiveRecord::Base
  self.table_name = "HEJIA_EDITOR"
  acts_as_readonlyable [:read_only_51hejia]
end
