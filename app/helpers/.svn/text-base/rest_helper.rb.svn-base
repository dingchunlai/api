module RestHelper
  def article_page_title
    if controller.controller_name == "article" && controller.action_name == "show"
      title_string = @article.TITLE
      first_tag = tag_name(@article.FIRSTCATEGORY)
      second_tag = tag_name(@article.SECONDCATEGORY)
      title_string << ("_" + second_tag) if second_tag
      title_string << ("_" + first_tag) if first_tag
      title_string << "_和家装修家居网"
    end
  end

  def article_navigation
    if controller.controller_name == "article" && controller.action_name == "show"
      domain = article_domain(@first_tag_url)
      first_tag = tag_name(@article.FIRSTCATEGORY)
      second_tag = tag_name(@article.SECONDCATEGORY)
      navigation_string = "<a target=\"_blank\" href=\"http://www.51hejia.com\">和家网</a>>"
      navigation_string << "<a target=\"_blank\" href=\"#{domain}#{@first_tag_url if !@pinpaiku.include?(@first_tag_url) and @first_tag_url!="zhuangxiu"}#{"/" if !@pinpaiku.include?(@first_tag_url) and @first_tag_url!="zhuangxiu"}\">#{first_tag}</a>>" if first_tag
      navigation_string << "<a target=\"_blank\" href=\"http://www.51hejia.com/articleList/s-#{@article.SECONDCATEGORY}\">#{second_tag}</a>>" if second_tag
      navigation_string << "&nbsp;&nbsp;&nbsp;正文#{@is_preview?"　<b style='color:red'>[预览状态]</b>":""}"
    end
  end

  #获取文章关键字
  def keywords_html(keywords, article_id)
    key = "key_publish_article_show_html_keywords_20100713_#{article_id}"
    CACHE.fetch(key, 1.month) do
      html = ""
      unless keywords.blank?
        keywords.lstrip.rstrip.split(";").each do |word|
          html << get_url_of_keyword(word.lstrip.rstrip)+"&nbsp;&nbsp;&nbsp;"
        end
      end
      html
    end
  end

  def article_link(article_id, create_time, first_category)
    first_tag_url = tag_url(first_category)
    domain = article_domain(first_tag_url)
    link = domain + "#{first_tag_url}/#{create_time.strftime("%Y%m%d")}/#{article_id}"
    link
  end

  def article_channel
    domain = article_domain(@first_tag_url)
    channel_url = domain
    channel_url << @first_tag_url unless @pinpaiku.include?(@first_tag_url) || @zhuangxiu.include?(@first_tag_url)
    channel_url << "/" unless @pinpaiku.include?(@first_tag_url) || @zhuangxiu.include?(@first_tag_url)
    channel_url
  end

  def article_domain(first_tag_url)
    if @zhuangxiu.include?(first_tag_url)
      domain = "http://d.51hejia.com/"
    elsif @pinpaiku.include?(first_tag_url)
      domain = "http://b.51hejia.com/"
    else
      domain = "http://www.51hejia.com/"
    end
    domain
  end

  def article_editor_id(edit_people, add_people)
    if edit_people
      edit_people
    elsif add_people
      user = RuserHuser.find(:first, :conditions => ["huser_id  = ?", add_people])
      user ? user.ruser_id : 0
    else
      0
    end
  end

  def related_articles(keywords, first_category)
    unless keywords.blank?
      word = keywords.lstrip.rstrip.split(";")[0]
      index_word = HejiaIndexKeyword.find(:first, :conditions => "name like '%#{word}%'")
      if index_word
        sql = "SELECT hi.* FROM hejia_indexes hi, relations re where re.keyword_id = #{index_word.id} and re.relation_type = 1 and re.entity_id = hi.entity_id and hi.entity_type_id = 1 and hi.entity_id != #{@article.ID} and hi.url like '%jushang%' order by entity_created_at desc limit 5;"
        #        key = "keyword_related_articles_#{index_word.id}_#{Time.now.strftime('%Y%m%d')}"
        articles = HejiaIndexKeyword.find_by_sql sql
        articles && articles.size == 5 ? articles : nil
      end
    end
  end

  def comment_height
    reply_count = @article.reply_count
    reply_count <= 7 ? (340 + (@article.reply_count * 40)) : 620
  end

  def related_article(first_category, second_category)
    key = "key_publish_article_show_about_#{first_category}_#{second_category}_#{Time.now.strftime("%Y-%m-%d")}"
    if CACHE.get(key).nil?
      conditions = ["STATE = '0'"]
      if second_category && second_category != 0
        conditions << "SECONDCATEGORY = #{second_category}"
      elsif first_category && first_category != 0
        conditions << "FIRSTCATEGORY = #{first_category}"
      end
      articles = HejiaArticle.find(:all, :select => "ID, TITLE, CREATETIME, FIRSTCATEGORY",
        :conditions => conditions.join(" and "), :limit => 6, :order => "SECONDORDERID DESC, CREATETIME DESC")
      CACHE.set(key, articles)
    else
      articles = CACHE.get(key)
    end
    return articles
  end

  def second_articles(second_category, limit, cache = true)
    sc = cache ? "" : second_category
    key = "key_publish_article_second_articles_12417_#{second_category}#{sc}_#{Time.now.strftime("%Y-%m-%d")}"
    if CACHE.get(key).nil?
      conditions = ["STATE = '0'"]
      if second_category && second_category != 0
        conditions << "SECONDCATEGORY = #{second_category}"
      else
        conditions << "FIRSTCATEGORY = 12417"
      end
      articles = HejiaArticle.find(:all, :select => "ID, TITLE, CREATETIME, FIRSTCATEGORY",
        :conditions => conditions.join(" and "), :limit => limit, :order => "SECONDORDERID DESC, CREATETIME DESC")
      CACHE.set(key, articles)
    else
      articles = CACHE.get(key)
    end
    return articles
  end

  def tag_name(id)
    tag = HejiaTag.find(:first, :select => "TAGNAME", :conditions => ["TAGID = ?", id])
    tag.TAGNAME if tag
  end
  
  def tag_url(id)
    tag = HejiaTag.find(:first, :select => "TAGURL", :conditions => ["TAGID = ?", id])
    tag.TAGURL if tag
  end

  def truncate_u(text, length = 30, truncate_string = "")
    l = 0
    char_array = text.unpack("U*")
    char_array.each_with_index do |c,i|
      l = l + (c<127 ? 0.5 : 1)
      if l >= length
        return char_array[0..i].pack("U*") + (i < char_array.length - 1 ? truncate_string : "")
      end
    end
    return text
  end
  # 文章终端页页底部嵌套页面article.rhtml获取12条优惠券信息
  def get12seoevents
    key = "zhaozhuangxiu_seo_events_112_#{Time.now.strftime('%Y%m%d%H')}"
    result = nil

    if CACHEZ.get(key).nil?
      result =  DecoEvent.find(:all,  :select => "deco_events,deco_events.id,deco_events.starts_at",  :order => "deco_events.id desc", :include => :firms, :limit=>12 )
      CACHEZ.set(key,result)
    else
      result = CACHEZ.get(key)
    end
    return result
  end
  
  #文章终端页页底部嵌套页面article.rhtml获取12条优惠券信息(新)
  def layouts_article_events
    city_code = get_user_city_for_ip
    DecoEvent
    Hejia[:cache].fetch("layouts:article:events:city:#{city_code}", 10.minutes) do 
      DecoEvent.coupon_lists(city_code,params).find(:all,:limit => 12)
    end
  end
  
  def layouts_article_cases
    city_code = get_user_city_for_ip
    HejiaCase
    Hejia[:cache].fetch("layouts:article:cases:city:#{city_code}", 10.minutes) do 
      HejiaCase.find(:all,
           :conditions => ["STATUS != '-100' and ISNEWCASE = 1 and ISZHUANGHUANG = '1' and (deco_firms.city = ? or deco_firms.district = ?) ",city_code, city_code],
           :joins => "join deco_firms on HEJIA_CASE.COMPANYID = deco_firms.id",
           :order => "CREATEDATE desc",:limit => 12)
    end
  end
  
  def layouts_article_firms
    city_code = get_user_city_for_ip
    DecoFirm
    Hejia[:cache].fetch("layouts:article:firms:city:#{city_code}", 10.minutes) do 
      DecoFirm.firms_list_for('',params,city_code).published.firm_list_order_for(1, city_code).find(:all,:limit => 6)
    end
  end 
  
  # 文章终端页右侧_sidebar.rhtml页面中最新网友装修点评部分
  def get3seoreviews
    DecorationDiary
    CACHE.fetch("atricle1:3/seo3/decoration_dairies", 1.hour) do
      DecorationDiary.find(:all,
                      :select => "decoration_diaries.id, decoration_diaies.deco_firm_id, decoration_diaries.title, decoration_diaries.content",
                      :conditions => [
                        "decoration_diaries.status = ?", 1
                      ],
                      :order => "decoration_diaries.updated_at desc",
                      :include => :deco_firm,
                      :limit => 3)
    end
  end

  # 文章终端页底部嵌套页面article.rhtml显示6条公司信息
  def get6seokoubeicompany
    key = "zhaozhuangxiu_koubei_company_seo_6_1#{Time.now.strftime('%Y%m%d%H')}"
    result = nil
    if CACHEZ.get(key).nil?
      result = DecoFirm.find(:all,:select=>"id,name_zh,name_abbr,total_score,city,district" ,:limit => 6, :order => "total_score desc")
      CACHEZ.set(key,result)
    else
      result = CACHEZ.get(key)
    end
    return result
  end
  # 文章终端页底部嵌套页面article.rhtml显示12条最新案例部分
  def get12topnewcase
    key = "zhaozhuangxiu_top_new_case_2_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      result = Case.find(:all,  :select=>"NAME, ID, PROVINCE1", :conditions => "STATUS!='-100' and ISNEWCASE=1 and TEMPLATE != 'room' and ISZHUANGHUANG='1'",  :order => "ID desc",  :limit => 12)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end
  # 文章终端页右侧_sidebar.rhtml页面中装修导航-找公司显示公司点评部分
  def get5goodreviews
    DecorationDiary
    CACHE.fetch("article/good5/decoration_diaries", 1.hour) do
      DecorationDiary.find(:all,
       :select => "decoration_diaries.title, decoration_diaries.id, decoration_diaries.deco_firm_id",  
       :conditions => "decoration_diaries.status = 1 and decoration_diaries.is_good = 1", 
       :order => "decoration_diaries.updated_at desc",  
       :limit  =>  5)
    end
  end

  #解析api对应栏目的xml输出
  def parse_xml_data(xml, parameters, end_num = nil)
    fetch_api_promotion_data xml, parameters, 0, end_num
  end
end
