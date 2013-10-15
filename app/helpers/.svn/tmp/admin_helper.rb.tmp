module AdminHelper
  def query_columns
    return [] if session[:editor_id].nil?
    groups = PublishColumnGroup.find(:all,
      :conditions => ["(editor_id = #{session[:editor_id]} or public_ids like ? ) and is_del = #{false}", "%#{session[:editor_id]}%"])
    group_ids_array = []
    groups.each { |g| group_ids_array << g.id }
    group_ids_string = group_ids_array.join(",")
    unless group_ids_string.blank?
      columns = PublishColumn.find(:all,
        :conditions => ["group_id in (#{group_ids_string}) and is_del = #{false}"])
      columns
    end
  end

  def query_ediror_name(id)
    RadminUser.find(id).rname rescue ""
  end
  def get_column_name_by_column_id(id)
    result = PublishColumn.find(id)
    return result.name if result
  end

  def get_style_name(text_style_id)
    pts = PublishTextStyle.find(:first, :conditions => ["style_key = ?", text_style_id])
    return pts.style_name
  end

  def get_style_by_text_style_id(title,text_style_id)
    pts = PublishTextStyle.find(:first, :conditions => ["style_key = ?", text_style_id])
    return pts.style_value.gsub("@title", title)
  end

  def selected(first_id, id)
    if first_id == id
      return "selected"
    end
  end

  def get_clear(str)
    if str.nil?
      return ""
    else
      str.gsub("&nbsp;", "").chars[0, 200]
    end
  end

  def query_shared_name(public_ids)
    unless public_ids.blank?
      names = []
      public_ids.split(",").each do |id|
        ru = RadminUser.find(id) rescue ""
        unless ru.blank?
          names << RadminUser.find(id).rname if ru.state.blank?
        end
        #names << RadminUser.find(id).rname rescue ""
      end
      names.join(",")
    else
      "无共享"
    end
  end

  #获得url和image_url
  def get_article_url_image_url(article_id, firstcategory, create_time, image_name)
    tag = HejiaTag.find(:first, :select => "TAGURL", :conditions => ["TAGID = ?", firstcategory])
    if tag.TAGURL == "zhuangxiu"
      url = "http://d.51hejia.com/#{tag.TAGURL}/#{create_time.strftime("%Y%m%d")}/#{article_id}"
    else
      url = "http://www.51hejia.com/#{tag.TAGURL}/#{create_time.strftime("%Y%m%d")}/#{article_id}"
    end
    if image_name.nil?
      image_url = "http://image.51hejia.com/files/hekea/article_img/jushang/#{article_id}.jpg"
    else
      image_url = "http://image.51hejia.com/files/hekea/article_img/sourceImage/#{image_name[3..10]}/#{image_name} "
    end
    return [url, image_url]
  end

  def get_image_url(image_url)
    if image_url
      image = image_url.include?("http") ? image_url : ("http://d.51hejia.com/api"+image_url)
      return image
    else
      image = "http://www.51hejia.com/api/images/none.gif"
      return image
    end
  end

  def query_small_image_url(id, main_photo)
    if main_photo
      image_url = "http://image.51hejia.com/files/hekea/case_img/small/#{main_photo}"
      return image_url
    else
      photo = PhotoPhoto.find(:first, :conditions => ["case_id = ?", id])
      if photo
        image_url = "http://image.51hejia.com/files/hekea/case_img/small/#{photo.filepath}"
        return image_url
      else
        image_url = "http://image.51hejia.com/api/images/none.gif"
        return image_url
      end
    end
  end
end
