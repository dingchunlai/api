module IndexHelper
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
  # home_friends_hot_talk_diary
  def friends_hot_diary city
    DecorationDiary.other_city_order_remarks_count city
  end
  # home_same_city_yesterday_remarks_top
  def city_yesterday_firms_remarks_tiptop(city)
    DecoFirm.city_yesterday_firms_remarks_tiptop(city)
  end
  
    #得到当前用户信息
  def get_user_info(id)
     HejiaUserBbs.hejia_bbs_user id
  end
end
def get_new_info_first(firstcategory,limitnum)
      tag = HejiaTag.find(:first, :select => "TAGURL", :conditions => ["TAGID = ?", firstcategory])
      articles = HejiaArticle.find(:all, :select => "ID, TITLE, CREATETIME, SUMMARY,IMAGENAME",
        :conditions => ["FIRSTCATEGORY = ? and STATE='0'", firstcategory], :limit => limitnum, :order => "SECONDORDERID DESC, CREATETIME DESC")
      results = Array.new
      articles.each do |article|
        one = Hash.new
        one["tag"] = "http://www.51hejia.com/#{tag.TAGURL}/"+article.CREATETIME.strftime("%Y%m%d")+"/"+article.ID.to_s
        if article.TITLE.nil?
          one["title"] = ""
        else
          one["title"] = article.TITLE
        end
        if article.IMAGENAME.nil?
          one["imageurl"]=""
        else
          one["imageurl"] ="http://www.51hejia.com/files/hekea/article_img/sourceImage/"+article.IMAGENAME.slice(3,8)+"/"+article.IMAGENAME
        end
        if article.SUMMARY.nil?
          one["summary"]=""
        else
          one["summary"]=article.SUMMARY
        end

        results << one
      end

      return results
end
def get_new_info(secondcategory,limitnum)
      articles = HejiaArticle.find(:all, :select => "ID, TITLE, CREATETIME, SUMMARY,IMAGENAME,FIRSTCATEGORY",
        :conditions => ["SECONDCATEGORY = ? and STATE='0'", secondcategory], :limit => limitnum, :order => "SECONDORDERID DESC, CREATETIME DESC")
      results = Array.new
      articles.each do |article|
        one = Hash.new
         if article.FIRSTCATEGORY
          tag = HejiaTag.find(:first, :select => "TAGURL", :conditions => ["TAGID = ?", article.FIRSTCATEGORY])
          one["tag"] = "http://www.51hejia.com/#{tag.TAGURL}/"+article.CREATETIME.strftime("%Y%m%d")+"/"+article.ID.to_s
         else
           one["tag"] = "http://www.51hejia.com/jushang/"+article.CREATETIME.strftime("%Y%m%d")+"/"+article.ID.to_s
         end
        if article.TITLE.nil?
          one["title"] = ""
        else
          one["title"] = article.TITLE
        end
        if article.IMAGENAME.nil?
          one["imageurl"]=""
        else
          one["imageurl"] ="http://www.51hejia.com/files/hekea/article_img/sourceImage/"+article.IMAGENAME.slice(3,8)+"/"+article.IMAGENAME
        end
        if article.SUMMARY.nil?
          one["summary"]=""
        else
          one["summary"]=article.SUMMARY
        end
        results << one
      end

      return results
end

