#按tag生成代码
def generatecodebytag options={}
  
  articles = Article.getarticlebytag( :brand => options[:brand],
                                     :first => options[:first], 
                                     :second => options[:second],
                                     :third => options[:third],
                                     :begintime => options[:begintime], 
                                     :endtime => options[:endtime], 
                                     :beginnum => options[:beginnum], 
                                     :allnum => options[:allnum], 
                                     :order => options[:order]  ) 
  
  return generateruby(:articles => articles,
                      :namelength => options[:namelength],
                      :deslength => options[:deslength],
                      :buju => options[:buju],
                      :classid =>options[:classid])
  
end

#按id生成代码
def generatecodebyid options={}
  
  articles = Article.getarticlebyid(:ids => options[:ids])
  
  return generateruby(:articles => articles,
                      :namelength => options[:namelength],
                      :deslength => options[:deslength],
                      :buju => options[:buju],
                      :classid =>options[:classid])  
end

#整理字符传
def generateruby options={}
  namelength = options[:namelength]
  deslength = options[:deslength]
  classid = options[:classid]
  buju = options[:buju]
  articles = options[:articles]
  
  str = ''
  buju = '21' if buju.nil?
  
  if buju == '21'
    str = str + '<ul>'
    articles.each do |article| 
      url = getarticleurl(article)
      str = str + "<li><a href='"+url+"' target='_blank' title='"+article.TITLE+"'>"+article.TITLE.chars[0,namelength.to_i]+"</a><span class=date>"+article.CREATETIME.strftime('%m-%d')+"</span></li> \n "
    end
    str = str + '</ul>'
  elsif buju == '22'
    str = str + '<ul>'
    articles.each do |article| 
      url = getarticleurl(article)
      str = str + "<li><a href='"+url+"' target='_blank' title='"+article.TITLE+"'>"+article.TITLE.chars[0,namelength.to_i]+"</a></li> \n "
    end
    str = str + '</ul>'
  elsif buju == '23'
    articles.each do |article| 
      url = getarticleurl(article)
      imgurl = getarticleimg(article)
      str = str + "<img src='"+imgurl+"' alt='"+article.TITLE+"'>"
      str = str + '<h4>'
      str = str + "<a href='"+url+"' target='_blank' title='"+article.TITLE+"'>"+article.TITLE.chars[0,namelength.to_i]+"</a></h4> \n "
      str = str + '<p>'+article.SUMMARY.chars[0,deslength.to_i] +'...[<a href='+url+' target=_blank>详细</a>]</p>'
    end  
  elsif buju == '24'
    articles.each do |article| 
      url = getarticleurl(article)
      imgurl = getarticleimg(article)
      str = str + '<h4>'
      str = str + "<a href='"+url+"' target='_blank' title='"+article.TITLE+"'>"+article.TITLE.chars[0,namelength.to_i]+"</a></h4> \n "
      str = str + '<p>'+article.SUMMARY.chars[0,deslength.to_i] +'...[<a href='+url+' target=_blank>详细</a>]</p>'
    end
  elsif buju == '25'
    str = str + '<dl>'
    articles.each do |article| 
      url = getarticleurl(article)
      imgurl = getarticleimg(article)
      str = str + '<dt><a href='+url+' target=_blank title='+article.TITLE+'><img src='+imgurl+' alt='+article.TITLE+'  height=97 border=0 /></a></dt>' 
      str = str + '<dd><a href='+url+' target=_blank title='+article.TITLE+'>' +article.TITLE.chars[0,12]+'</a></dd>' 
    end
    str = str + '</dl>'     
  elsif buju == '26'
    articles.each do |article| 
      url = getarticleurl(article)
      imgurl = getarticleimg(article)
      str = str + '<a href='+url+' target=_blank title='+article.TITLE+'><img src='+imgurl+' alt='+article.TITLE+' border=0 width=150 height=95 /></a>' 
    end
  end
  
  return str
end

#文章url
def getarticleurl(article)
  
  if article.TEMPURL && !article.TEMPURL.blank
    return article.TEMPURL
  end
  
  domain = 'http://www.51hejia.com/'
  if article.article_type1 && article.article_type1.TAGURL == 'zhuangxiu' 
    domain = 'http://d.51hejia.com/' 
  end  
  if article.article_type1 && article.article_type1.TAGURL != '' 
    domain = domain + article.article_type1.TAGURL + '/' 
  end 
  if article.CREATETIME 
    domain = domain + article.CREATETIME.strftime('%Y%m%d') + '/' 	 
  end 
  domain = domain + article.ID.to_s 
  
  return domain
end

#文章图片地址
def getarticleimg(article)
  img = 'http://d.51hejia.com/api/images/none.gif' 
  if article.IMAGENAME 
    img = 'http://www.51hejia.com/files/hekea/article_img/sourceImage/'+article.IMAGENAME.slice(3,8)+'/'+article.IMAGENAME 
  end  
  
  return img
end

HEJIA_API_URL_PATTERN = %r'http://api\.51hejia\.com/rest/build/xml/(\d+\.)xml'.freeze unless defined?(HEJIA_API_URL_PATTERN)
NUMBER_PATTERN = /^\d+$/.freeze unless defined?(NUMBER_PATTERN)
HTTP_URL_PATTERN = %r'\Ahttp://'.freeze unless defined?(HTTP_URL_PATTERN)

# 原来项目中，parse_xml的方法异常混乱，这个方法就是为了可以兼容以前所有parse_xml方法而
# 诞生的。本方法其实是对hejia_ext_links的api推广的相关方法作进一步封装，达到兼容的目的。
def fetch_api_promotion_data(url_or_id, parameters, from = nil, to = nil, delete_cache = false)
  from ||= 0
  limit = to && (to - from)
  column_id =
    case url_or_id.to_s
    when NUMBER_PATTERN
      url_or_id
    when HEJIA_API_URL_PATTERN
      $1
    end
  if column_id
    CACHE.delete("key_publish_article_right_column_#{column_id}/#{from}/#{to}") if delete_cache
    CACHE.fetch("key_publish_article_right_column_#{column_id}/#{from}/#{to}", 30.minutes) do
      options = {}
      column_names     = parameters.map { |p| p.gsub('-', '_') }
      options[:select] = column_names.dup
      options[:offset] = from if from > 0
      options[:limit]  = limit if limit
      ::Hejia::Promotion.items(column_id, options).map do |item|
        h = {}
        parameters.each_with_index do |param, index|
          column = column_names[index]
          # 为了兼容原有的用法
          h[param] = h[column] =
            if column == 'image_url'
              item[column].blank? && 'http://img.51hejia.com/api/images/none.gif' ||
                item[column] !~ HTTP_URL_PATTERN && (::Hejia::Promotion::ASSET_URL + item[column]) ||
                item[column]
            else
              item[column]
            end || ''
        end
        h
      end # inject
    end # fetch
  else
    []
  end
end

#解析api对应栏目的xml输出
def parse_xml(xml, parameters, end_num = nil)
  fetch_api_promotion_data xml, parameters, 0, end_num
end
  
  #解析api对应栏目的xml输出
def parse_xml2(xml, parameters, begin_num = 0, end_num = nil)
  fetch_api_promotion_data xml, parameters, begin_num, end_num
end

def get_domain(city_id)
  if IS_PRODUCT.to_i == 1
    if city_id.to_i == 11910
      return 'http://z.shanghai.51hejia.com'
    elsif city_id.to_i == 12117
      return 'http://z.suzhou.51hejia.com'
    elsif city_id.to_i == 12122
      return 'http://z.nanjing.51hejia.com'
    elsif city_id.to_i == 12301
      return 'http://z.ningbo.51hejia.com'
    elsif city_id.to_i == 12306
      return 'http://z.hangzhou.51hejia.com'
    elsif city_id.to_i == 12118
      return 'http://z.wuxi.51hejia.com'
    else
      return 'http://z.51hejia.com'
    end    
  else
    return ''
  end
end


