class HejiaArticleCol < ActiveRecord::Base
  self.table_name = "HEJIA_ARTICLE_COL"
  acts_as_readonlyable [:read_only_51hejia]
end
