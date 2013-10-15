class GasController < ApplicationController
  def index
    #热点关注
    @hot_articles = HejiaArticle.search(41382, 18)
    @hot_articles.each do |a|
      logger.info a.ID
    end
    #燃气具产品资讯
    @product_news = HejiaArticle.search(41383, 9)
    #维护保养小常识
    @tending = HejiaArticle.search(41384, 9)
    #产品评测应用
    @product_test = HejiaArticle.search(41385, 8)
    #编辑推荐
    @editor_recommend = HejiaArticle.search(41386, 8)
  end
end
