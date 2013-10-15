class HejiaIndexKeyword < Hejia::Db::Index
#  include IndexConn
#  acts_as_readonlyable [:read_only_51hejia_index]

  def keyword_articles
    sql = "SELECT hi.* FROM hejia_indexes hi, relations re where re.keyword_id = #{self.id} and re.relation_type = 1 and re.entity_id = hi.entity_id and hi.entity_type_id = 1 order by entity_created_at desc limit 5;"
    key = "keyword_articles_#{self.id}_#{Time.now.strftime('%Y%m%d')}"
    if CACHE.get(key).nil?
      articles = HejiaIndex.find_by_sql sql
      CACHE.set(key, articles)
    else
      articles = CACHE.get(key)
    end
    return articles
  end
  
  
end
