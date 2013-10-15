class HejiaTagEntityLink < ActiveRecord::Base
    self.table_name = "HEJIA_TAG_ENTITY_LINK"
    acts_as_readonlyable [:read_only_51hejia]
end
