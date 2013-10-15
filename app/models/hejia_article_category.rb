class HejiaArticleCategory < ActiveRecord::Base
  self.table_name = "HEJIA_ARTICLE_CATEGORY"
  acts_as_readonlyable [:read_only_51hejia]
end
