require 'open-uri'
require 'rexml/document'
module ArticleHelper

  #获得一级频道url
  def get_first_tag_url(firstcategory)
    if !firstcategory.nil?
      tag = HejiaTag.find(:first, :select => "TAGURL", :conditions => ["TAGID = ?", firstcategory])
      return tag.TAGURL if tag
    end
  end

  #获得一级频道名称
  def get_first_tag_name(firstcategory)
    if !firstcategory.nil?
      tag = HejiaTag.find(:first, :select => "TAGNAME", :conditions => ["TAGID = ?", firstcategory])
      return tag.TAGNAME if tag
    end
  end
  #通过Tagid对应的Tagfatherid的Tagname
  def get_father_tag_name(tagid)
    if !tagid.nil?
      fatherid = HejiaTag.find(:first, :select => "TAGFATHERID", :conditions => ["TAGID = ?", tagid])
      if !fatherid.nil?
        if tagid.to_i == 41721
          return "采暖频道"
        else
          tag= HejiaTag.find(:first, :select => "TAGNAME", :conditions => ["TAGID = ?", fatherid.TAGFATHERID])
          if !tag.nil?
            return tag.TAGNAME if tag
          else
            return ""
          end
        end
      else
        return ""
      end
    else
      return ""
    end
  end
  #获得二级频道名称
  def get_second_tag_name(secondcategory)
    if !secondcategory.nil?
      tag = HejiaTag.find(:first, :select => "TAGNAME", :conditions => ["TAGID = ?", secondcategory])
      return tag.TAGNAME if tag
    end
  end

  #获得产品核价url
  def get_product_hejia_url_product_name(a_id, e_id, page_num)
    if page_num.nil?
      i = 1.to_i
    else
      i = page_num
    end
    pro = HejiaArtProdLink.find(:first, :conditions => ["ARTICLEID = ? and MARK = ?", a_id, i])
    if !pro.nil?
      if pro.PRODUCTID.nil?
        url = "http://p.51hejia.com/pricings/new?pname=#{pro.PRODUCTNAME}&&eid=#{e_id}&&aid=#{a_id}"
      else
        url = "http://p.51hejia.com/pricings/new?pid=#{pro.PRODUCTID}&&eid=#{e_id}&&aid=#{a_id}"
      end
      return [url, pro.PRODUCTNAME]
    end
  end

  #获得产品信息
  def get_product_info(a_id, page_num)
    if page_num.nil?
      i = 1
    else
      i = page_num
    end
    pro = HejiaArtProdLink.find(:first, :conditions => ["ARTICLEID = ? and MARK = ?", a_id, i.to_i])
    if !pro.nil?
      if pro.PRODUCTID.nil?
        return nil
      else
        pro2 = Product.find(:first, :select => "id, vendor_id, name, description, now_price, liveness",
          :conditions => ["productid = ? ", pro.PRODUCTID])
        if !pro2.nil?
          pro_vendor = ProductVendor.find(:first, :select => "id, address, name_zh", :conditions => ["id = ?", pro2.vendor_id])
          product_image = ProductImage.find(:first, :conditions => ["product_id = ?", pro2.id])
          if product_image.nil?
            image_url = "http://api.51hejia.com/images/none.gif"
          else
            image_url = product_image.full_path(:thumbnail)
          end
          if pro_vendor.address.nil?
            info1 = "公司名称：#{pro_vendor.name_zh}"
          else
            info1 = "门店地址：#{pro_vendor.address}"
          end
          if pro2.description.nil?
            info2 = "暂无产品描述"
          else
            info2 = "产品描述：#{pro2.description}"
          end
          info = "<div class='artbomdes'>核价次数：#{pro2.liveness}次<br/>"+info1+"<br/><br/>"+info2+"<br /></div>"
          price = "<td><div class='cankao'>参考价：#{pro2.now_price}元</div></td>"
          return [info, price, image_url]
        else
          return ["", "", ""]
        end
      end
    end
  end

  #获得二级相关新闻
  def get_about_news(s, f)
    if s && s != 0
      secondcategory = s
    else
      secondcategory = f
    end
    if CACHE.get("key_publish_article_show_about_#{secondcategory}_#{Time.now.strftime("%Y-%m-%d")}").nil?
      articles = HejiaArticle.find(:all, :select => "ID, TITLE, CREATETIME, FIRSTCATEGORY",
        :conditions => ["SECONDCATEGORY = ?", secondcategory], :limit => 10, :order => "SECONDORDERID DESC, CREATETIME DESC")
      #      p articles.size
      results = Array.new
      for article in articles 
        one = Hash.new
        if article.FIRSTCATEGORY
          tag = HejiaTag.find(:first, :select => "TAGURL", :conditions => ["TAGID = ?", article.FIRSTCATEGORY])
          one["title"] = article.TITLE
          if tag.nil?
            one["url"] = "http://www.51hejia.com"
          else
            if tag.TAGURL == "zhuangxiu"
              one["url"] = "http://d.51hejia.com/#{tag.TAGURL}/#{article.CREATETIME.strftime("%Y%m%d")}/#{article.ID}"
            elsif @first_tag_url == "pinpaiku"
              one["url"] = "http://b.51hejia.com/#{tag.TAGURL}/#{article.CREATETIME.strftime("%Y%m%d")}/#{article.ID}"
            else
              one["url"] = "http://www.51hejia.com/#{tag.TAGURL}/#{article.CREATETIME.strftime("%Y%m%d")}/#{article.ID}"
            end
          end
          results << one
        end
      end
      CACHE.set("key_publish_article_show_about_news_#{secondcategory}", results)
    else
      results = CACHE.get("key_publish_article_show_about_news_#{secondcategory}")
    end
    return results
  end

  #获得一级相关新闻
  def get_first_about_news(firstcategory)
    if CACHE.get("key_publish_article_show_about_#{firstcategory}_#{Time.now.strftime("%Y-%m-%d")}").nil?
      articles = HejiaArticle.find(:all, :select => "ID, TITLE, CREATETIME, FIRSTCATEGORY",
        :conditions => ["FIRSTCATEGORY = ?", firstcategory], :limit => 10, :order => "SECONDORDERID DESC, CREATETIME DESC")
      results = Array.new
      for article in articles
        one = Hash.new
        tag = HejiaTag.find(:first, :select => "TAGURL", :conditions => ["TAGID = ?", article.FIRSTCATEGORY])
        one["title"] = article.TITLE
        if tag.TAGURL == "zhuangxiu"
          one["url"] = "http://d.51hejia.com/#{tag.TAGURL}/#{article.CREATETIME.strftime("%Y%m%d")}/#{article.ID}"
        elsif @first_tag_url == "pinpaiku"
          one["url"] = "http://b.51hejia.com/#{tag.TAGURL}/#{article.CREATETIME.strftime("%Y%m%d")}/#{article.ID}"
        else
          one["url"] = "http://www.51hejia.com/#{tag.TAGURL}/#{article.CREATETIME.strftime("%Y%m%d")}/#{article.ID}"
        end
        results << one
      end
      CACHE.set("key_publish_article_show_about_news_#{firstcategory}", results)
    else
      results = CACHE.get("key_publish_article_show_about_news_#{firstcategory}")
    end
    return results
  end

  #获得作者名字
  def get_author_name(u_id, author)
    if author.nil?
      bbs_user = HejiaUserBbs.find(:first, :conditions => ["USERBBSID = ?", u_id])
      return bbs_user.USERBBSNAME
    else
      return author
    end
  end

  #获得url和image_url
  def get_article_url_image_url(article_id, firstcategory, create_time, image_name)
    tag = HejiaTag.find(:first, :select => "TAGURL", :conditions => ["TAGID = ?", firstcategory])
    unless tag.nil?
      if tag.TAGURL == "zhuangxiu"
        url = "http://d.51hejia.com/#{tag.TAGURL}/#{create_time.strftime("%Y%m%d")}/#{article_id}"
      elsif tag.TAGURL == "pinpaiku"
        url = "http://b.51hejia.com/#{tag.TAGURL}/#{create_time.strftime("%Y%m%d")}/#{article_id}"
      else
        url = "http://www.51hejia.com/#{tag.TAGURL}/#{create_time.strftime("%Y%m%d")}/#{article_id}"
      end
    end
    if image_name.nil?
      image_url = "http://www.51hejia.com/api/images/none.gif"
    else
      if image_name.include?("img")
        image_url = "http://d.51hejia.com/files/hekea/article_img/sourceImage/#{image_name[3..10]}/#{image_name} "
      else
        image_url = "http://d.51hejia.com/files/hekea/article_img/sourceImage/#{create_time.strftime("%Y%m%d")}/#{image_name} "
      end
    end
    return [url, image_url]
  end

  #根据i的奇偶获得不同的class
  # 此方法可直接在视图中使用cycle方法
  #  def get_class_by_i(i)
  #    if i.odd?
  #      return "lbdleft mar"
  #    else
  #      return "lbdleft"
  #    end
  #  end

  #居尚文章列表页导航样式
  def get_current_by_tag_id(id, tag_id)
    unless tag_id.nil?
      if id == tag_id.to_i
        return "id=\"current\""
      end
    else
      if id == 0
        return "id=\"current\""
      end
    end
  end
  #获取第一级分类最新１０篇文章
  def get_first_wenzhang(firstcategory)
    now = Time.now.strftime("%Y%m%d")
    key = "key_publish_article_show_content_#{now}"
    
    if CACHE.get(key).nil?      
      wenzhang = HejiaArticle.find(:all, :select => "ID, TITLE",
        :conditions => ["FIRSTCATEGORY = ?", firstcategory], :limit => 10, :order => "FIRSTCATEGORY DESC, CREATETIME DESC")
      if !wenzhang.nil?
        result = Array.new
        for w in wenzhang
          one = Hash.new
          one["title"] = w.TITLE
          one["url"] = w.ID.to_s
          result << one
        end
        CACHE.set(key, result)
        return result
      else
        return  nil
      end
    else      
      return CACHE.get(key)
    end
   
  end

  #获取文章关键字
  def get_html_of_keywords(keywords, article_id)
    html = ""
    key = "key_publish_article_show_html_keywords_20100713_#{article_id}"
    if CACHE.get(key).nil?
      if keywords.blank? or keywords.nil?
      else
        a = keywords.lstrip.rstrip.split(";")
        0.upto(a.size-1) do |i|
          html += get_url_of_keyword(a[i].lstrip.rstrip)+"&nbsp;&nbsp;&nbsp;"
        end
      end
      CACHE.set(key, html)
    else
      html = CACHE.get(key)
    end
    return html
  end

  #  获取文章关键字url
  #  频道链接=>新专区链接=>老专区链接=>Tag链接
  def get_url_of_keyword(keyword)
    url = ""
    if HASH_KEYWORDS[keyword].nil?
      zhuanqu_sort = ZhuanquSort.find(:first, :select=>"id, board_id", :conditions => ["is_delete = 0 and sort_name = ?", keyword])
      zhuanqu_kw = ZhuanquKw.find(:first, :select=>"id, sort_id", :conditions => ["is_delete = 0 and kw_name = ?", keyword])
      if zhuanqu_sort.nil? and zhuanqu_kw.nil?
        zhuanqu = ZhuanquInfo.find(:first, :conditions => ["name = ? and is_del != 0 and state = 1", keyword])
        if zhuanqu.nil?
          url = "<a href=\"http://tag.51hejia.com/#{u(keyword)}.html\" target=\"_blank\">#{keyword}</a>"
        else
          url = "<a href=\"http://www.51hejia.com/zhuanqu/#{u(keyword)}.html\" target=\"_blank\">#{keyword}</a>"
        end
      else
        url = get_url_of_new_special_area(zhuanqu_sort, zhuanqu_kw, keyword)
      end
    else
      url = "<a href=\"#{HASH_KEYWORDS[keyword]}\" target=\"_blank\">#{keyword}</a>"
    end
    return url
  end

  def get_url_of_new_special_area(zhuanqu_sort, zhuanqu_kw, keyword)
    url = ""
    if !zhuanqu_sort.nil?
      url = "<a href=\"http://#{ZHUANQU_BOARD_SPELL[zhuanqu_sort.board_id.to_i]}.51hejia.com/zq/#{u(keyword)}\" target=\"_blank\">#{keyword}</a>"
    else !zhuanqu_kw.nil?
      s = ZhuanquSort.find(zhuanqu_kw.sort_id, :select=>"id, board_id, sort_name")
      sort_name = s.sort_name rescue ""
      board_id = s.board_id
      url = "<a href=\"http://#{ZHUANQU_BOARD_SPELL[board_id.to_i]}.51hejia.com/zq/#{u(sort_name)}-#{u(keyword)}.html\" target=\"_blank\">#{keyword}</a>"
    end
    return url
  end

  def case_cover_image(id, type_id, mphoto)
    if type_id == 5 || type_id == -5
      image_url = "http://image.51hejia.com#{mphoto}"
    else
      image_url = "http://image.51hejia.com/files/hekea/case_img/tn/#{id}.jpg"
    end
    return image_url
  end

  def cooperation_company_cases
    key = "key_article_cooperation_company_cases_#{Time.now.strftime("%Y-%m-%d")}"
    if CACHE.get(key).nil?
      sql = "SELECT c.ID, c.NAME, c.MAINPHOTO, c.DESIGNERID, c.TYPE_ID, c.CREATEDATE FROM HEJIA_CASE c, HEJIA_COMPANY hc " +
        "where c.COMPANYID = hc.ID and hc.SPECIAL = 1 and c.STATUS != -100 and c.ID >= (SELECT floor(RAND() * (SELECT MAX(ID) FROM HEJIA_CASE))) limit 10;"
      cases = HejiaCase.find_by_sql sql
      CACHE.set(key, cases)
      return cases
    else
      cases = CACHE.get(key)
      return cases
    end
  end

  #风格，户型，费用，用途
  def four_tags
    key = "key_article_cooperation_company_tags_#{Time.now.strftime("%Y-%m-%d")}"
    if CACHE.get(key).nil?
      sql = "SELECT TAGID, TAGFATHERID, TAGNAME FROM HEJIA_TAG where TAGFATHERID in (4348, 4352, 4347, 4349) order by TAGFATHERID;"
      tags = HejiaTag.find_by_sql sql
      return tags
    else
      tags = CACHE.get(key)
      return tags
    end
  end

  def match_tag_id(keywords)
    unless keywords.blank?
      a = keywords.lstrip.rstrip.split(";")
      tags = four_tags
      a.each do |item|
        tags.each do |tag|
          return tag.TAGID if item.match(tag.TAGNAME) or tag.TAGNAME.match(item)
        end
      end
    end 
  end

  def cooperation_company_tag_cases(keywords, article_id)
    key = "key_article_cooperation_company_tag_cases_#{article_id}_#{Time.now.strftime("%Y-%m-%d")}"
    if CACHE.get(key).nil?
      tag_id = match_tag_id(keywords)
      if tag_id.is_a?(Integer)
        sql = "SELECT c.ID, c.NAME, c.MAINPHOTO, c.DESIGNERID, c.TYPE_ID FROM HEJIA_CASE c, HEJIA_TAG_ENTITY_LINK ht " +
          "where c.STATUS != -100 and c.ID = ht.ENTITYID and c.ISZHUANGHUANG != 1 and ht.LINKTYPE = 'case' and ht.TAGID = #{tag_id} and c.ID >= (SELECT floor(RAND() * (SELECT MAX(ID) FROM HEJIA_CASE))) limit 10;"
        cases = HejiaCase.find_by_sql sql
      else
        sql = "SELECT c.ID, c.NAME, c.MAINPHOTO, c.DESIGNERID, c.TYPE_ID, c.CREATEDATE FROM HEJIA_CASE c, HEJIA_COMPANY hc where c.COMPANYID = hc.ID and hc.SPECIAL = 1 and c.STATUS != -100 and c.ID >= (SELECT floor(RAND() * (SELECT MAX(ID) FROM HEJIA_CASE))) limit 10;"
        cases = HejiaCase.find_by_sql sql
      end
      CACHE.set(key, cases)
      return cases
    else
      cases = CACHE.get(key)
      return cases
    end
  end

  def case_tyle(id)
    sql = "SELECT distinct(t.TAGID), t.TAGNAME FROM HEJIA_TAG_ENTITY_LINK l, HEJIA_TAG t where l.ENTITYID=#{id} and l.LINKTYPE='case' and l.TAGID = t.TAGID and t.TAGFATHERID=4348 limit 1;"
    tag = HejiaTag.find_by_sql sql
    tag if tag
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
  
  # 页面生成跳转链接
  # @params[:deco] =  DecoEvent || Case || DecoReview || DecoFirm
  # @return url 根据对象所处的城市生成具体的跳转地址
  # 特殊处理部分 
  # 由于信息点评信息全部都是和日记相关联 也就说所有的点评都会跳向自己所关联的日记链接上(但是由于个别的点评并没有跟日记想关联)
  def deco_url(deco)
    one = 1
    url = ""
    city = city_name(deco)  if IS_PRODUCT == one
    domain =  "http://z.#{city}.51hejia.com" if IS_PRODUCT == one
    if deco.is_a?(DecoEvent)
      url = (IS_PRODUCT == one ? domain : "") + "/gs-#{deco.firms[0].id}/y-#{deco.id}"
    elsif deco.is_a?(Case)
      url = (IS_PRODUCT == one ? domain : "") + "/gs-#{deco.PROVINCE1}/cases-#{deco.id}"
    elsif deco.is_a?(DecoFirm)
      url = (IS_PRODUCT == one ? domain : "") + "/gs-#{deco.id}"
    elsif deco.is_a?(DecorationDiary)
      url = (IS_PRODUCT == one ? domain : "") + "/gs-#{deco.deco_firm_id}/zhuangxiugushi/#{deco.id}"
    end
    url
  end
  
  # 根据不同的对象取出它们对应的公司所处的城市
  # @params[:deco] =  DecoEvent || Case || DecoReview || DecoFirm
  # @return domain_city 城市对应的拼音名称
  def city_name(deco)
    city = 11910
    domain_city = ""
    firm = nil
    if deco.is_a?(DecoEvent)
      firm = deco.firms[0] if deco.firms && deco.firms.size > 0
    elsif deco.is_a?(Case)
      city = deco.PROVINCE1.to_i
    elsif deco.is_a?(DecoFirm)
      firm = deco
    elsif deco.is_a?(DecorationDiary)
      firm = deco.deco_firm
    end
    if firm
      city = firm.city.to_i == 11910 ?  firm.city : firm.district
    end
    domain_city = TAGURLS[city] 
  end

  def gen_firm_link_address(firm)
    city_id = firm.city.to_i == 11910 ?  firm.city : firm.district
    "http://z.#{TAGURLS[city_id]}.51hejia.com/gs-#{firm.id}"
  end
  
end
