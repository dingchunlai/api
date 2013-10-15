# Methods added to this helper will be available to all templates in the application.
include PublicModule
require 'open-uri'
require 'rexml/document'
include DecoHelper
include IpHelper

module ApplicationHelper

  #阅读模式按钮
  def read_mode_button
    name = (params[:page] == 'all' ? '分页模式' : '全文模式')
    page = (params[:page] == 'all' ? nil : 'all')
    link_to name, {:page => page}, :style => 'color: red', :title => "点击使用#{name}浏览文章..."
  end

  def render_ad(id, remark="", type="afp")
    remark = "#{type}广告代码　" + remark + "　"
    if type=="afp"
      <<START

      <!-- #{remark + "START　" + "="*30} -->
      <script type="text/javascript">//<![CDATA[
      ac_as_id = #{id};
      ac_format = 0;
      ac_mode = 1;
      ac_group_id = 1;
      ac_server_base_url = "afp.csbew.com/";
      //]]></script>
      <script type="text/javascript" src="http://static.csbew.com/k.js"></script>
      <!-- #{remark + "END　" + "="*32} -->
START
    elsif type=="openx"
      <<START

      <!-- #{remark + "START　" + "="*30} -->
      <script type='text/javascript'><!--//<![CDATA[
      var m3_u = (location.protocol=='https:'?'https://a.51hejia.com/www/delivery/ajs.php':'http://a.51hejia.com/www/delivery/ajs.php');
      var m3_r = Math.floor(Math.random()*99999999999);
      if (!document.MAX_used) document.MAX_used = ',';
      document.write ("<scr"+"ipt type='text/javascript' src='"+m3_u);
      document.write ("?zoneid=#{id}");
      document.write ('&amp;cb=' + m3_r);
      if (document.MAX_used != ',') document.write ("&amp;exclude=" + document.MAX_used);
      document.write (document.charset ? '&amp;charset='+document.charset : (document.characterSet ? '&amp;charset='+document.characterSet : ''));
      document.write ("&amp;loc=" + escape(window.location));
      if (document.referrer) document.write ("&amp;referer=" + escape(document.referrer));
      if (document.context) document.write ("&context=" + escape(document.context));
      if (document.mmm_fo) document.write ("&amp;mmm_fo=1");
      document.write ("'><\/scr"+"ipt>");
      //]]>--></script>
      <!-- #{remark + "END　" + "="*32} -->
START
    end
  end
  
  #解析api对应栏目的xml输出
  def parse_xml(xml, parameters, end_num = nil)
    fetch_api_promotion_data xml, parameters, 0, end_num
  end 

  def e(str)
    return URI.escape(utf8_to_gb2312(str))
  end
  def utf8_to_gb2312(str)
    begin
      str ? Iconv.iconv("gb2312", "UTF-8", str).join("") : str;
    rescue
      str;
    end
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
  
  def record_visit_test(host,key)
    REDIS_DB["#{key}"]    
  end
  
  # Query Builder page for a list of links to journal
  # params[:type] => model
  # params[:tag] => hejia_tag
  # params[:value] => hejia_tag_value
  # return url
  def generate_base_tag_url(type, tag, value)
    url = ''
    if type == "deco_note"
      if tag == "method"
        url = "/zhuangxiugushi/#{value}-0-0-0-0-1-0-1-2"
      elsif tag == "style"
        url = "/zhuangxiugushi/0-#{value}-0-0-0-1-0-1-2"
      elsif tag == "price"
        url = "/zhuangxiugushi/0-0-#{value}-0-0-1-0-1-2"
      elsif tag == "room"
        url = "/zhuangxiugushi/0-0-0-0-#{value}-1-0-1-2"
      end
    end
    url
  end
  
  
  # According to the company, generates a contains an array of cities and regions 
  # 根据当前公司对象得到对应该公司的城市和地区编号装入一个两个元素的数组中
  # params[:firm_id] = firm.id
  # return array
  # array[0] = city
  # array[1] = area
  def generate_firm_city_area firm_id
    CACHE.fetch("/firm/city/area/url/#{firm_id}", 1.day) do
      city_and_area = []
      firm = DecoFirm.getfirm firm_id
      if firm.city.to_i == 11910
        city_and_area << firm.city 
        city_and_area << firm.district
      else
        city_and_area <<  firm.district
        city_and_area <<  firm.area
      end
      city_and_area
    end
  end
  
  # Synthesis of the current url
  def current_url
    url = ""
    url.concat request.protocol
    url.concat request.env['SERVER_NAME']
    url.concat request.request_uri
    url
  end
  
  #ajax分页 --jquery
  def will_paginate_remote(paginator, options={})
    update = options.delete(:update)
    url = options.delete(:url)
    params = options.delete(:params)
    str = will_paginate(paginator, options)
    if str != nil
      str.gsub(/href="(.*?)"/) do
        "href=\"#\" onclick=\"jQuery('#"+update+"').load( '" + (url ? url + $1.sub(/[^\?]*/, '') : $1) + params +
          "', {asynchronous:true, evalScripts:true, method:'get'}); return false;\""
      end
    end
  end
  
  #引用jquery
  def include_jquery
    content_for(:head) { '<script type="text/javascript" src=" http://ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.min.js"></script> '}
  end
  
  #自动的stylesheet
  def api_stylesheet(*args)
    if RAILS_ENV == "development" || RAILS_ENV == "staging"
      content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
    elsif RAILS_ENV == "rehearsal"
      content_for(:head) { stylesheet_link_tag(*args.map{|s| "http://js.51hejia.com/css/api/rehearsal/" + s.to_s  + "?" + Time.now.to_i.to_s })}
    else
      content_for(:head) { stylesheet_link_tag(*args.map{|s| "http://js.51hejia.com/css/api/" + s.to_s  + "?" + Time.now.to_i.to_s })}
    end
  end
  
  def api_javascript(*args)
    if RAILS_ENV == "development" || RAILS_ENV == "staging"
      content_for(:head) { javascript_include_tag(*args) }
    elsif RAILS_ENV == "rehearsal"
      content_for(:head) { javascript_include_tag(*args.map{|s| "http://js.51hejia.com/js/api/rehearsal/" + s.to_s + "?" + Time.now.to_i.to_s }) }
    else
      content_for(:head) { javascript_include_tag(*args.map{|s| "http://js.51hejia.com/js/api/" + s.to_s + "?" + Time.now.to_i.to_s }) }
    end
  end
  
  # 生成相同城市下的装修日记跳转连接地址
  # options {firm_id,diary_id}
  # return diary_url
  def generate_same_city_diary_url(options = {})
    "/gs-#{options[:firm_id]}/zhuangxiugushi/#{options[:diary_id]}"
  end
  
  # cached_current generate_diary_object
  def decoration_diary id
    DecorationDiary.getNote id
  end
  
  # 返回和家用户所属的城市名称
  # params[:hejia_bbs_user_id] 对象或者主键值
  # return user_city_name
  def hejia_bbs_user_city_name hejia_bbs_user_id
    CACHE.fetch("hejia_bbs_user/city_name/#{hejia_bbs_user_id}/", 1.day) do
      hejia_bbs_user = unless hejia_bbs_user_id.is_a?(HejiaUserBbs).blank?
        HejiaUserBbs.hejia_bbs_user hejia_bbs_user_id.id 
      else
        HejiaUserBbs.hejia_bbs_user hejia_bbs_user_id
      end
      city = hejia_bbs_user.AREA.to_i == 11910 ? hejia_bbs_user.AREA.to_i : hejia_bbs_user.CITY.to_i
      hejia_tag = HejiaTag.find_by_TAGID city
      hejia_tag && hejia_tag.TAGNAME || '地址不详'
    end
  end
  
  # strip_html_except options(tags, include)
  # options[:tags] html_tags
  # options[:include] inclde_except_html_tags (true or false) include is true ,except is false
  def whitelist_strip_tags(html, options = {})
    return html if html.blank?
    if html.index('<')
      text = ""
      whitelist = options[:tags] || []
      tokenizer = HTML::Tokenizer.new(html)
      while token = tokenizer.next
        node = HTML::Node.parse(nil, 0, 0, token, false)
        text << node.to_s if HTML::Text === node || (options[:include] ? whitelist.include?(node.name) : !whitelist.include?(node.name))
      end
      text.gsub(/<!--(.*?)-->[\n]?/m, '')
    else
      html
    end
  end
  
  # get hejia_bbs_user_export_counts
  def has_many_hejia_bbs_user_export_number
    HejiaUserBbs.has_many_hejia_bbs_user_number
  end
  
  # get decoration_diaries_counts
  def has_many_decoration_diaries_number
    DecorationDiary.has_many_decoration_diaries_number
  end
  
  # get remark_counts
  def has_many_net_friend_remarks_number
    Remark.net_friend_remarks_number
  end
  
  # get deco_firm_counts
  def has_many_deco_firm_number
    DecoFirm.has_many_deco_firm_number
  end
  
  
  # diff_city_generate_diff_price
  def diff_city_price_tag city
    #price = city.to_i == 12301 ? NINBO_PRICE : PRICE.sort
    #宁波的价格也更改为同上海一样
    PRICE.sort
  end
  
  # 根据城市和标签得到城市标签对应的价格
  def diff_city_price_tag_value(city, key)
    price_name = ""
    if city.to_i == 12301
      price = PRICE#宁波的价格也更改为同上海一样
      price.select{|k, v| price_name = v if k == key.to_i}
    else
      price = PRICE
      price_name = price[key.to_i]
    end
    price_name
  end
  
  # has_not_cached home top_8_price_firms
  def index_home_city_price_firms(city, price, number)
    DecoFirm.index_home_city_price_firms(city, price, number)
  end
  # has_not_cached home top_8_style_firms
  def index_home_city_style_firms(city, style, number)
    DecoFirm.index_home_city_style_firms(city, style, number)
  end
  
  # get_promoted_firms index | home
  def home_same_promoted_firms(city, tag, key)
    Picture
    PUBLISH_CACHE.fetch("da_shou_ye/paihangbang/#{city}/#{tag}/#{key}", RAILS_ENV != 'production' ? 0 : 1.hour) do
      promoted_firms = []
      promoted_xml_id = THE_CHARTS_PROMOTED[city] && THE_CHARTS_PROMOTED[city][tag][key]
      unless promoted_xml_id.blank?
        promoted_ids = parse_xml(promoted_xml_id,["title"]).map{|item| item['title'].to_i }
        promoted_ids.each do |id|
          firm = DecoFirm.getfirm(id)
          promoted_firms << firm unless firm.blank?
        end
      end
      promoted_firms
    end
  end
  
  # 显示公司星星
  # params[:num] 公司星级数
  # params[:show_gray_star] 是否显示灰星
  # params[:margin_top] 当显示灰星时控制样式
  def show_firm_star(num, show_gray_star = true, margin_top = 2)
    if num.to_i > 5
      %(<label style="width: #{(num.to_i-5) * 18}px; margin-top: #{margin_top + 4}px;" class="gsr_integral01 f_l"></label>)
    elsif num.to_i >0 && num.to_i <= 5
      %(<label style="width: #{num.to_i * 18}px; margin-top: #{margin_top}px;" class="gsr_integral02 f_l"></label>)
    elsif  num.to_i == 0 && show_gray_star == true
      %(<label style="width: 18px; margin-top: #{margin_top}px;" class="gsr_integral03 f_l"></label>)
    end
  end
  
  # add generate_firm_path
  def generate_firm_path firm
    CACHE.fetch("appliaction/generate_firm_path/#{firm}", 1.hour) do
      firm = firm.is_a?(DecoFirm) ? firm : DecoFirm.getfirm(firm)
      city = firm.city == 11910 ? firm.city.to_i : firm.district.to_i
      city_name = TAGURLS[city]
      "http://z.#{city_name}.51hejia.com/#{firm.id}/"
    end
  end

  # 移除页面上外部链接
  def remove_external_links text
    text.gsub!(%r'(https?://|www\.)[[:graph:]]+') { |a| a =~ %r'http://([^/])*\.51hejia\.com' ? a : '' }
    text
  end  
  #留言星星
  def show_remark_star num
    PublicModule.remark_star num
  end

  #9月16号，用于上海首页的最的价位排行
  def shang_hai_zuixi_price
    SHANGHAI_PRICE
  end

  def ul(str, len, preview=0, replacer="...")
    if preview == 1
      str = ""
      99.times { str += "预览内容" }
    end
    str = strip_tags(str.to_s)
    if str.length > 0
      s = str.split(//u)
      if s.length > len.to_i && len.to_i != 0
        return s[0, len.to_i].to_s + replacer
      else
        return str
      end
    else
      return ""
    end
  end

  def index_extra_price_firms city
    DecoFirm::extra_price_firms(city)
  end

  def index_extra_style_firms city
    DecoFirm::extra_style_firms(city)
  end

  def index_extra_5_price_firms city
    DecoFirm::extra_5_price_firms(city)
  end

  def index_extra_5_style_firms city
    DecoFirm::extra_5_style_firms(city)
  end

  def find_other_cooperation_firms(city, option, value, need_size)
    DecoFirm::find_other_cooperation_firms(city, option, value, need_size)
  end

  def get_diary_master_picture(diary)
    Picture
    CACHE.fetch("get_master_picture/decoration_diary/#{diary.id}", RAILS_ENV != 'production' ? 0 : 1.hour) do
      diary.master_picture
    end
  end


  def diary_pictures_size(diary)
    CACHE.fetch("get_diary_pictures_size/decoration_diary/#{diary.id}", RAILS_ENV != 'production' ? 0 : 1.hour) do
      sum = 0
      diary.decoration_diary_posts.each do |body|
        sum += body.pictures.size
      end
      return sum
    end
  end

  def diary_remarks_size(diary)
    CACHE.fetch("get_diary_remarks_size/decoration_diary/#{diary.id}", RAILS_ENV != 'production' ? 0 : 1.hour) do
      sum = 0
      diary.decoration_diary_posts.each do |body|
        sum += body.remarks.size
      end
      return sum
    end
  end
  
  def truncate_char(str , options = nil)
    length = options[:length] || 100
    omission = options[:omission] || ''
    truncate(str, length, omission)
  end

  def diary_remarks_count(id)
    diary = DecorationDiary.find(id)
    diary_remarks_size(diary)
  end
  
  #得到当前用户的城市
  def get_user_city_for_ip
    city = remote_city
    city_code = city[:number]
  end

  def firm_order_at_brands_index(number, city, promoted, limit)
    CACHE.fetch("api/index/home/firms/city_style_firms/#{number}/#{city}/#{promoted}/#{limit}", RAILS_ENV == 'development' ? 1 : 15.minutes) do
      DecoFirm.price_top_ten(number, city, promoted, limit)
    end
  end
  
end
