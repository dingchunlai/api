class HejiaArticle < ActiveRecord::Base
  has_many :replies, :foreign_key => "entity_id", :conditions => "area_id = 1 and type_id = 1"
  self.table_name = "HEJIA_ARTICLE"
  self.primary_key = "ID"
  acts_as_readonlyable [:read_only_51hejia]
  
  belongs_to :article_type1,
  :class_name => "HejiaTag",
  :foreign_key => "FIRSTCATEGORY"
  
  has_finder :published, :conditions => " STATE = '0'"
  has_finder :secondcategory_is, lambda {|category| { :conditions => {:SECONDCATEGORY => category} ,:limit=>6}}

  belongs_to :first_tag, :class_name => 'HejiaTag', :foreign_key => 'FIRSTCATEGORY'

  def self.same_secondcategory_articles article
    CACHE.fetch "articles:same_secondcategory_articless:#{article.SECONDCATEGORY}", 1.hour do
      HejiaArticle.published.secondcategory_is(article.SECONDCATEGORY).find(:all,:limit=>6,:order=>"CREATETIME desc")
    end
  end

  def reply_count
    replies ? replies.size : 0
  end

  #生成HTML头部过期时间
  def headers_expire
    created_at = read_attribute("CREATETIME")
    created_at = Time.local(2010,1,1,12,30,0) if created_at.nil?
    now = Time.now
    expire = Time.local(now.year,now.month,now.day,created_at.hour,created_at.min,created_at.sec)
    expire = expire + 12.hours if expire <= now
    expire.httpdate
  end

  #转载声明
  def statement
    if read_attribute("SOURCE").to_s.strip == "原创[带版权]"
      "转载声明：此文系和家网原创稿件，如需转载，请注明出处（和家网）及作者，违者本网将追究责任！<br /><br />"
    else
      ""
    end
  end

  #来源
  def SOURCE
    source = read_attribute("SOURCE").to_s
    if source.include?("原创")
      "原创"
    else
      source
    end
  end

  #品牌库的导购评测文章
  def self.daogou_pingce_articles(limit)
    max_limit = 10
    fail '参数limit不能比max_limit大' if limit > max_limit
    key = "hejia_article_daogou_pingce_articles_#{max_limit}"
    rs = CACHE.fetch(key, 1.hour) do
      HejiaArticle.find(:all,
        :select => "ID, TITLE, AUTHOR, CONTENTID, CREATETIME, FIRSTCATEGORY",
        :conditions => ["STATE = 0 and FIRSTCATEGORY = ? and CHECK_BRAND in (2, 3)", 42092],
        :order => "CREATETIME DESC", :limit => max_limit)
    end
    rs[0...limit]
  end

  def self.articles(limit = 10, second_category = 0, by = 'time', first_category = 0)
    max_limit = 10
    fail '参数limit不能比max_limit大' if limit > max_limit
    key = "hejia_articles_#{first_category}_#{second_category}_#{max_limit}_#{by}"
    rs = CACHE.fetch(key, 1.hour) do
      conditions = ["STATE = 0"]
      conditions << "FIRSTCATEGORY = #{first_category}" if first_category.to_i > 0
      conditions << "SECONDCATEGORY = #{second_category}" if second_category.to_i > 0
      #按时间取最新文章
      if by == 'time'
        order = "CREATETIME DESC"
        #按浏览量取人气最高的文章
      elsif by == 'hot'
        #这部分逻辑待定，先用 order = "CREATETIME DESC" 代替
        order = "CREATETIME DESC"
      else
        fail 'by参数值错误！'
      end
      HejiaArticle.find(:all,
        :select => "ID, TITLE, AUTHOR, CONTENTID, CREATETIME, FIRSTCATEGORY",
        :conditions => conditions.join(" and "),
        :order => order, :limit => max_limit)
    end
    rs[0...limit]
  end

  def self.search(thirdcategory, limit)
    results = HejiaArticle.find(:all,
      :select => "ID, TITLE, AUTHOR, IMAGENAME, CONTENTID, CREATETIME, FIRSTCATEGORY",
      :conditions => ["STATE = 0 and THIRDCATEGORY = ?", thirdcategory],
      :order => "THIRDORDERID DESC, CREATETIME DESC", :limit => limit)
    return results
  end
  
  def self.getzhuangxiuarticle
    key = "zhuangxiu_article_pinglun_right_#{Time.now.strftime('%Y%m%d%H')}"
    result = []
    if CACHE.get(key).nil?
      result = find(:all ,:select => "ID,TITLE,CREATETIME" ,
        :conditions => "STATE = 0 and FIRSTCATEGORY='12394'",
        :order => "CREATETIME desc",
        :limit => 15)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    
    return result
  end

  def self.brand_articles
    key = "key_publish_brand_articles_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      result = HejiaArticle.find(:all,
        :select => "ID, TITLE, AUTHOR, CONTENTID, CREATETIME, FIRSTCATEGORY",
        :conditions => ["STATE = 0 and FIRSTCATEGORY = ?", 42092],
        :order => "CREATETIME DESC", :limit => 10)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    result
  end

  def self.getarticlebytag options={}

    brand = options[:brand]
    first = options[:first]
    second = options[:second]
    third = options[:third]
    begintime = options[:begintime]
    endtime = options[:endtime]
    order = options[:order]
    beginnum = options[:beginnum]
    allnum = options[:allnum]

    conditions = []
    conditions << "STATE='0'"
    conditions << "BRAND_ID = #{brand}" if brand && brand != '0'
    conditions << "FIRSTCATEGORY = '#{first}'" if first && first != '0'
    conditions << "SECONDCATEGORY = '#{second}'" if second && second != '0'
    conditions << "THIRDCATEGORY = '#{third}'" if third && third != '0'
    conditions << "CREATETIME >= '#{begintime}'" if begintime && begintime != ''
    conditions << "CREATETIME <= '#{endtime}'" if endtime && endtime != ''

    if order == '4'
      orderstr = ' PV asc '
    elsif order == '3'
      orderstr = ' PV desc '
    elsif order == '2'
      orderstr = ' ID asc '
    elsif order == '1'
      orderstr = ' ID desc '
    elsif order == '5'
      orderstr = ' FIRSTORDERID desc,ID desc '
    elsif order == '6'
      orderstr = ' SECONDORDERID desc,ID desc '
    elsif order == '7'
      orderstr = ' THIRDORDERID desc,ID desc '
    end

    if beginnum && allnum
      articles = find(:all,
                      :conditions => conditions.join(" and "),
                      :order => orderstr,
                      :offset => beginnum,
                      :limit => allnum)

      return articles
    else
      return nil
    end

  end

  def next_article
    HejiaArticle.find(:first,
      :select => "ID, TITLE, AUTHOR, CONTENTID, CREATETIME, FIRSTCATEGORY",
      :conditions => ["ID < ? and FIRSTORDERID <> -1 and STATE = 0 and FIRSTCATEGORY = ?", self.ID, self.FIRSTCATEGORY],
      :order => "ID desc")
  end
end
