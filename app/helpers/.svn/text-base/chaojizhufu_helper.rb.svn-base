module ChaojizhufuHelper
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
      one["tag"] = "http://www.51hejia.com/chaojizhufu/"+article.CREATETIME.strftime("%Y%m%d")+"/"+article.ID.to_s
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

