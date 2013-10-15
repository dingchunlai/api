class HejiaCompany < ActiveRecord::Base
  self.table_name = "HEJIA_COMPANY"
  acts_as_readonlyable [:read_only_51hejia]
end
