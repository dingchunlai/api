# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require "_user"
require "rubygems"
require "redis"

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  require "_generate"
  
  helper_method :fetch_api_promotion_data, :remote_city

  include ::RailsResourceMonit::MemoryUsageLogger
  helper [:decoration_diary, :deco_firm]
  before_filter  :preload_models
  
  helper RelateTagsHelper
  include PublicModule
  include IpHelper
  
  def preload_models()
    HejiaIndex
    HejiaCase
    HejiaArticle
    HejiaArticleContent
    Case
    CaseCompany
    CaseDesigner
    PothoTag
    DecoFirm
    Case
    CaseFactoryCompany
    DecoVedio
    DecoPhoto
    DecoReview
    DecoEvent
    CaseTag
    PhotoPhoto
    PothoTag
    DecoRegister
    CaseMaterial
    AskZhidaoTopic
    AskBlogTopic
    Product
    HejiaTag
    PhotoPhotosTag
  end

  def paginate_collection(collection, options = {})
    default_options = {:per_page => 1, :page => 1}
    options = default_options.merge options

    pages = Paginator.new self, collection.size, options[:per_page], options[:page]
    first = pages.current.offset
    last = [first + options[:per_page], collection.size].min
    slice = collection[first...last]
    return [pages, slice]
  end
  
  #从redis中获取form token
  def get_form_token_from_redis
    @token = REDIS_DB.get "#{session.session_id}:form_token"
  end
  private :get_form_token_from_redis
  
  def store_url_from
    session[:url_from] = request.request_uri
  end

  #  def record_article_visit(value)
  #    #    unless File.exist?("public/article_visit_record")
  #    #      Dir.mkdir("public/article_visit_record")
  #    #    end
  #    key = generate_key
  #    file_name = Time.now.strftime("%Y-%m-%d")
  #    logger.info "create start --------------------------"
  #    db = BDB::Btree.create("public/article_visit_record/#{file_name}.db", nil, BDB::CREATE)
  #    logger.info "create end --------------------------"
  #    db[key] = value
  #    db.close
  #  end

  def record_article_visit(host, key)
    begin
      REDIS_DB.incr("#{key}")
    rescue => exception
      logger.info exception
    end
  end
  
  def record_visit_test(host,key)
    REDIS_DB["#{key}"]
  end

  def generate_key
    string_to_hash = Time.now.to_s + rand.to_s
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def get_start_end_date(date)
    year = date[0,4]
    month = date[4,date.size]
    days = days_in_month(month.to_i, year.to_i)
    time1 = Time.parse(month+"/1"+"/"+year)
    time2 = Time.parse(month+"/#{days}"+"/"+year)
    return [time1.strftime("%Y-%m-%d %H:%M:%S"), time2.strftime("%Y-%m-%d %H:%M:%S")]
  end
  

  
  def get_start_end_date2(date1,date2)
    year1 = date1[0,4]
    year2 = date2[0,4]
    month1 = date1[4,date1.size]
    month2 = date2[4,date2.size]

    days1 = days_in_month(month1.to_i, year1.to_i)
    days2 = days_in_month(month2.to_i, year2.to_i)

    time11 = Time.parse(month1+"/1"+"/"+year1)
    #time12 = Time.parse(month1+"/#{days1}"+"/"+year1)
    #time21 = Time.parse(month2+"/1"+"/"+year2)
    time22 = Time.parse(month2+"/#{days2}"+"/"+year2)

    return [time11.strftime("%Y-%m-%d %H:%M:%S"), time22.strftime("%Y-%m-%d %H:%M:%S")]
  end
  def days_in_month(month, year=nil)
    if month == 2
      !year.nil? && (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0)) ?  29 : 28
    elsif month <= 7
      month % 2 == 0 ? 30 : 31
    else
      month % 2 == 0 ? 31 : 30
    end
  end


  def iconv_gb18030(str)
    begin
      str ? Iconv.iconv("UTF-8", "gb18030", str).join("") : str;
    rescue
      str;
    end
  end
  
  def iconv_gb2312(str)
    begin
      str ? Iconv.iconv("UTF-8", "gb2312", str).join("") : str;
    rescue
      str;
    end
  end
  
  def iconv_utf8(str)
    begin
      str ? Iconv.iconv("gb18030", "UTF-8", str).join("") : str;
    rescue
      str;
    end
  end

  def get_editor_id_by_cookie_name(cookie_name="ind_id")
    cookie = cookies["#{cookie_name}"]
    if cookie.nil?
      user_id = 0
    else
      user_id = cookie.to_s
      user_id = user_id.gsub("#{cookie_name}=", "").gsub("; path=", "").to_i
    end
    return user_id
  end

  def is_editor
    user_id = get_editor_id_by_cookie_name()
    if user_id > 0
      ohurs = HejiaUserRole.find(:all, :select => "role_id",
        :conditions => ["user_id = ?", user_id])
      if ohurs.size > 0
        is_editor = 0
        for ohur in ohurs
          role_id = ohur.role_id
          role_name = HejiaRole.find(:first, :select => "name",
            :conditions => ["id = ?", role_id]).name
          if role_name == "编辑"
            is_editor = 1
            break
          end
        end
        if is_editor == 1
          #编辑登录
        else  #非编辑登录
          redirect_to "/"
        end
      else  #非编辑登录
        redirect_to "/"
      end
    else  #未登录
      redirect_to "/"
    end
  end

  #创建xml文件
  def build_xml_file(id)
    now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    if File.exist?("public/rest/build/xml/#{id}.xml")
      File.rename("public/rest/build/xml/#{id}.xml", "public/rest/build/xml/bak/#{id}.xml")
    end
    @publish_contents = PublishContent.find(:all,
      :select => "title,left(description,200) as description,url,image_url,entity_created_at,entity_updated_at,entity_type_id,media_type_id,text_style_id,order_id,publish_time,expire_time,price_ago,price_now,person_style",
      :conditions => ["publish_column_id = ? and is_valid = ? and is_del = #{false} and publish_time < ? and expire_time > ?", id, 2, now, now],
      :order => "order_id DESC, entity_created_at DESC")
    file = File.new("public/rest/build/xml/#{id}.xml","w+")
    doc = REXML::Document.new
    publish_contents = REXML::Element.new "publish_contents"
    for pc in @publish_contents
      publish_content = publish_contents.add_element "publish_content"
      t_node = publish_content.add_element "title"
      t_node.text  = pc.title
      d_node = publish_content.add_element "description"
      d_node.text  = pc.description == "" ? "暂无描述" : pc.description
      u_node = publish_content.add_element "url"
      u_node.text  = pc.url == "" ? "http://www.51hejia.com" : pc.url
      iu_node = publish_content.add_element "image-url"
      iu_node.text  = pc.image_url.nil? ? "http://d.51hejia.com/api/images/none.gif" : pc.image_url
      pt_node = publish_content.add_element "publish-time"
      pt_node.text  = pc.publish_time
      et_node = publish_content.add_element "expire-time"
      et_node.text  = pc.expire_time
      oi_node = publish_content.add_element "order-id"
      oi_node.text  = pc.order_id
      tsi_node = publish_content.add_element "text-style-id"
      tsi_node.text  = pc.text_style_id
      mti_node = publish_content.add_element "media-type-id"
      mti_node.text  = pc.media_type_id
      eti_node = publish_content.add_element "entity-type-id"
      eti_node.text  = pc.entity_type_id
      eua_node = publish_content.add_element "entity-updated-at"
      eua_node.text  = pc.entity_updated_at
      eca_node = publish_content.add_element "entity-created-at"
      eca_node.text  = pc.entity_created_at
      oi_node = publish_content.add_element "price_ago"
      oi_node.text  = pc.price_ago
      oi_node = publish_content.add_element "price_now"
      oi_node.text  = pc.price_now
      oi_node = publish_content.add_element "person_style"
      oi_node.text  = pc.person_style
    end
    doc.add_element publish_contents
    file.puts doc
    file.close
  end

  #获得url和image_url
  def get_article_url_image_url(article_id, firstcategory, create_time, image_name)
    tag = HejiaTag.find(:first, :select => "TAGURL", :conditions => ["TAGID = ?", firstcategory])
    if tag.TAGURL == "zhuangxiu"
      url = "http://d.51hejia.com/#{tag.TAGURL}/#{create_time.strftime("%Y%m%d")}/#{article_id}.r"
    elsif tag.TAGURL == "pinpaiku"
      url = "http://b.51hejia.com/#{tag.TAGURL}/#{create_time.strftime("%Y%m%d")}/#{article_id}.r"
    else
      url = "http://www.51hejia.com/#{tag.TAGURL}/#{create_time.strftime("%Y%m%d")}/#{article_id}.r"
    end
    if image_name.nil?
      image_url = "http://image.51hejia.com/files/hekea/article_img/jushang/#{article_id}.jpg"
    else
      image_url = "http://image.51hejia.com/files/hekea/article_img/sourceImage/#{image_name[3..10]}/#{image_name} "
    end
    return [url, image_url]
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

  def get_params(user_id, article_id, channel, editor_id)
    option = { :entity_type_id => 1, :entity_id => article_id,
      :channel => channel, :visitor_ip => request.remote_ip().to_s,
      :visitor_id => user_id, :editor_id => editor_id}
    option
  end

  def page_not_found!
    render :file => File.join(RAILS_ROOT, 'public/404.html'), :status => 404
  end
  
  def redirect_301_to url
    headers["Status"] = "301 Moved Permanently"
    redirect_to url
  end
  
  # get firm_path
  def get_firm_path firm
    CACHE.fetch("appliaction/get_firm_path/#{firm}", 1.hour) do
      firm = firm.is_a?(DecoFirm) ? firm : DecoFirm.getfirm(firm)
      city = firm.city == 11910 ? firm.city.to_i : firm.district.to_i
      city_name = TAGURLS[city]
      "http://z.#{city_name}.51hejia.com/gs-#{firm.id}/"
    end
  end
  
  # get_browsed_firms 
  # cookies[:browsed_firms] = [include(firm.id)]  
  def get_browsed_firms
    if browsed_firms = cookies[:browsed_firms]
      @browsed_firms = DecoFirm.find  browsed_firms.split(',').map(&:to_i)
    end
    true
  end
  private :get_browsed_firms
  # get_browesd_diary
  # cookies[:browsed_diaris] = [include(diary_id)]  
  def get_browsed_diaries
    if browsed_diaries = cookies[:browsed_diaries]
      @browsed_diaries = DecorationDiary.find(:all,:conditions => ['id in (?)', browsed_diaries.split(',').map(&:to_i)])
    end
    true
  end
  private :get_browsed_diaries

  # 验证公司是否与用户访问的子域名相符。
  # 如：苏州的公司，访问的子域名应该是suzhou.51hejia.com。
  # 主要提供给before_filter使用。
  # @param [Symbol] id_param_name 公司id的参数名称，默认为:id
  # @yield [DecoFirm] 如果验证失败，则执行block，参数为当前访问的公司
  # @return [DecoFirm] 返回公司对象
  def validates_firm_with_subdomain(id_param_name = :id)
    firm = DecoFirm.getfirm params[id_param_name]
    
    if firm
      #判断域名和公司是否匹配
      subdomain = request.subdomains.to_s

      if firm.city == 11910 && !subdomain.include?("shanghai")
        yield firm
      elsif firm.city != 11910
        if (city_subdomain = TAGURLS[firm.district]).blank?
          page_not_found!
        elsif !subdomain.include?(city_subdomain)
          yield firm
        end
      end
    else # firm is nil
      page_not_found!
    end

    firm
  end
  protected :validates_firm_with_subdomain

  # 传入一个时间，如果当前模式是开发模式的话，返回1（就是开发模式下，所有缓存都只缓存一秒钟）；其它模式下，返回传入的值。
  def expires_time(time)
    RAILS_ENV == 'development' ? 1 : time
  end
  protected :expires_time
  helper_method :expires_time
end
