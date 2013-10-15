module GasHelper
  #获得url和image_url
  def get_url(article_id, firstcategory, create_time)
    tag = HejiaTag.find(:first, :select => "TAGURL", :conditions => ["TAGID = ?", firstcategory])
    if tag.TAGURL == "zhuangxiu"
      url = "http://d.51hejia.com/#{tag.TAGURL}/#{create_time.strftime("%Y%m%d")}/#{article_id}"
    elsif tag.TAGURL == "jiadian"
      url = "http://www.51hejia.com/gas/#{create_time.strftime("%Y%m%d")}/#{article_id}"
    else 
      url = "http://www.51hejia.com/#{tag.TAGURL}/#{create_time.strftime("%Y%m%d")}/#{article_id}"
    end
    return url
  end
end
