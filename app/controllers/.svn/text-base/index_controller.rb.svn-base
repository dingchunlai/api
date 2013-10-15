class IndexController < DecoController
  include IpHelper
  include Decoration::Validation
  before_filter :city_validate, :only => [:home]
  before_filter :get_browsed_firms, :only => [:home]
  
  caches_action :d_index, :cache_path => :d_index_cache_path.to_proc, :expires_in => 10.minutes
  
  layout 'application'
  # new home
  def home
    @city = params["city"]
    city_name = TAGURLS[@city.to_i]
    limit_top = (@city.to_i == 12301 || @city.to_i == 12118) ? 9 : 10 #宁波、无锡显示9条
    DecorationDiary
    @home =  CACHE.fetch("home/page_cache_/#{@city}", 1) do
      {
        "网友家居秀" => parse_xml(INDEX_PROMOTED[city_name]["网友家居秀"], ["title"], 3),
        "通告栏" => parse_xml(INDEX_PROMOTED[city_name]["通告栏"],["title","url"], 4),
        "热点案例" => parse_xml(INDEX_PROMOTED[city_name]["热点案例"], ["title"], 1),
        "最新更新" => parse_xml(INDEX_PROMOTED[city_name]["最新更新"], ["title"], 3),
        "更多案例" => parse_xml(INDEX_PROMOTED[city_name]["更多案例"], ["title"], 6),
        "今日最热点评" => DecoFirm.city_yesterday_firms_diaries_tiptop(@city),
        "网友热议日记" => DecorationDiary.other_city_order_remarks_count(@city),
        "优惠券数量" => (AREA_PROMOTED['首页优惠券数量'][city_name] || 6),
        "装修优惠券" => parse_xml(INDEX_PROMOTED[city_name]["装修优惠券"], ["title", "url", "image-url"], (AREA_PROMOTED['首页优惠券数量'][city_name] || 6)),
        "专题" => parse_xml(INDEX_PROMOTED[city_name]["专题"], ["title","url"], limit_top),
        "专访" => parse_xml(INDEX_PROMOTED[city_name]["专访"], ["title","url"], limit_top)
      }
    end
  end

  $title_id = 'sy'
  #上海

  #首页登录渲染模版 (因线上首页为静态页面,特用此方法)
  def render_home_login
   @user_ind_id = current_user.USERBBSID if current_user  #从COOKIE取出当前用户的ID。判断是否登陆
   if @user_ind_id
   user_info = HejiaUserBbs.hejia_bbs_user @user_ind_id.to_i
   count_sum = HejiaUserBbs.get_user_count_sum(@user_ind_id.to_i)

   if HejiaUserBbs.find(@user_ind_id).decoration_diaries.verified_from_now_on.size >= 1
     show_html = <<start
            document.write("<div class='zxdpn_p1r_login2'><ul><li>用户名：<strong>#{user_info.USERNAME}</strong></li>");
            document.write("<li><label>已发表装修图片：<strong>#{count_sum[0]}</strong>张</label>");
            document.write("<label>网友回复：<strong>#{count_sum[1]}</strong>个</label>");
            document.write("<label>装修故事被浏览量：<strong>#{count_sum[2]}</strong></label></li></ul>");
            document.write("<span><a href='http://member.51hejia.com/decoration_diaries/' target='_blank' title='日记列表'>[日记列表]</a></span></div>");
start
   else
   show_html = <<start
            document.write("<div class='zxdpn_p1r_login2'><ul><li>用户名：<strong>#{user_info.USERNAME}</strong></li>");
            document.write("<li><label>已发表装修图片：<strong>#{count_sum[0]}</strong>张</label>");
            document.write("<label>网友回复：<strong>#{count_sum[1]}</strong>个</label>");
            document.write("<label>装修故事被浏览量：<strong>#{count_sum[2]}</strong></label></li></ul>");
            document.write("<span><a href='http://member.51hejia.com/decoration_diaries/new' target='_blank' title='新建日记'>[新建日记]</a></span></div>");
start
   end
   render :text => show_html
   else
    render :text => "document.write('');"
   end
  end
  
  #d.51hejia.com 的首页.
  #以前是静态页面.现搞到项目 里去.
  #暂时只改要改的部分,以后慢慢和谐
  def d_index
    city = remote_city
    city_code = city[:number].to_i
    @coupons = DecoEvent.coupon_lists(city_code,params).find(:all,:limit => 4)
    @home_diaries = parse_xml(D_HOME_INDEX[TAGURLS[city_code]]["首页装修日记"], ["title","url"], 5)
    render :layout =>  false
  end
  
  #d.51hejia.com的缓存地址
  def d_index_cache_path
     city = remote_city
     city_code = city[:number]
     "d/index/home/cache/#{city_code}"
   end
  
end
