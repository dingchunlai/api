class AfpController < ApplicationController
  enable_subdomain_filter
  add_subdomain_filter 'api' => :others # 不能通过routes.rb来限制，因为routes里面有默认的:controller/:action。太恶心了。

  @@hejia_host_pattern = %r'\Ahttp://([^\.]+\.)?51hejia\.com(:\d+)?'.freeze

  # /afp?a=53257,23389,43103,0.8|12345,22345,32345,0.6,http://www.my.parner/ad/path
  def index
    referer = request.referer
    #referer = 'http://www.51hejia.com'
    return not_found! if referer.blank? || referer !~ @@hejia_host_pattern

    code = AfpAd.find_by_url(referer).map! { |ad|
      next unless ad.can_access_from?(current_user_location)
      #js_code ad
      js_code_new ad
    }.join
    if code.blank? then not_found!
    else
      expires_now
      response.content_type = Mime::JS
      render :text => code 
    end
  end

  def stat
    # do not use time stamp from params!
    afp_ad = AfpAd.find_by_ad_id(params[:ad_id])
    if afp_ad
      afp_ad_stat = AfpAdStat.find(:first,
                                   :conditions => ['ad_id = ? and stat_date = ?',
                                   afp_ad.ad_id,
                                   Time.now.to_date]) || AfpAdStat.create(
                                   { :ad_id => afp_ad.ad_id, :stat_date => Time.now.to_date }.update( AfpAd.get_hours_hits(afp_ad.max_hits, afp_ad.floating_rate) ))
      hour = Time.now.hour
      h_column = "hits_hour#{hour}".to_sym
      current_hour_hits = afp_ad_stat.send(h_column)
      # 记录点击
      ad_click = AfpAdClick.new(:ad_id => afp_ad.ad_id, :ip => request.env["HTTP_X_FORWARDED_FOR"] || request.env['REMOTE_ADDR'], :clk_time => Time.now)

      if ad_click.save && afp_ad_stat.update_attributes(:hits => afp_ad_stat.hits + 1, h_column => current_hour_hits + 1)
        render :text => 'ok'
      else
        render :text => "err"
      end
    else
      not_found!
    end
  end

  def admin
    return render :text => "请先登录。", :content_type => Mime::HTML, :status => 403 unless current_staff
    return render :text => "你没有权限。", :content_type => Mime::HTML, :status => 403 unless current_staff.admin? || current_staff.member_of?('广告管理')

    if request.post?
      if params[:op] == 'clear' then clear_ads
      elsif params[:afp_ad]     then save_ad
      elsif params[:afp_page]   then save_page
      end
    end
   
    if params[:op] == 'edit'
      @afp_ad   = AfpAd.find_by_id params[:ad_id] if params[:ad_id]
      @afp_page = AfpPage.find_by_id params[:ad_page_id] if params[:ad_page_id]
    end

    @ads    = AfpAd.find :all, :order => 'ad_id'
    @pages  = AfpPage.find :all, :order => 'afp_pages.id', :include => 'ads'

    render :layout => false
  end

  private

  def clear_ads
    AfpAd.clear_expired_ads 
    flash[:success] = '过期广告清除成功'
  end

  def save_ad
    @afp_ad = params[:afp_ad][:id].blank? ? AfpAd.new : AfpAd.find(params[:afp_ad][:id])
    @afp_ad.attributes = params[:afp_ad]
    @afp_ad.rate = 0.01
    if @afp_ad.save
      @afp_ad = nil
      flash[:success] = '广告保存成功'
    else
      flash[:alert] = '广告保存失败'
    end
  end

  def save_page
    @afp_page = params[:afp_page][:id].blank? ? AfpPage.new : AfpPage.find(params[:afp_page][:id])
    @afp_page.attributes = params[:afp_page]
    if @afp_page.save
      @afp_page = nil
      flash[:success] = '页面保存成功'
    else
      flash[:alter] = '页面保存失败'
    end
  end

  def not_found!
    render :nothing => true, :status => 204
  end

  def js_code_new(ad)
    unless ad.max_hits == 0
      now = Time.now
      # begin_of_hour = Time.parse(now.strftime("%Y-%m-%d %H:00:00"))
      current_hour = now.hour
      
      stat = AfpAdStat.find(:first, :select => "id, ad_id, hits, max_hits, hour#{current_hour}, hits_hour#{current_hour}", :conditions => ['ad_id = ? and stat_date = ?', ad.ad_id, now.to_date]) || AfpAdStat.create( { :ad_id => ad.ad_id, :stat_date => now.to_date }.update( AfpAd.get_hours_hits(ad.max_hits, ad.floating_rate) ))

      current_hour_hits = stat.send("hits_hour#{current_hour}".to_sym)

      current_hour_limit = stat.send("hour#{current_hour}".to_sym)

      return "" if current_hour_limit == 0 #当前时段无点击

      if stat.hits >= stat.max_hits
        return ""
      else
        if current_hour_hits >= current_hour_limit
          return ""
        else
          client_ip = request.env["HTTP_X_FORWARDED_FOR"] || request.env['REMOTE_ADDR']

          # 每分钟可点击数
          per_minute_hits = current_hour_limit.to_f / 60

          if per_minute_hits < 1 # 每分钟不到一次
            # 当前小时的所有量
            time_hour_now = Time.parse(now.strftime("%Y-%m-%d %H:00:00"))
            clicks = AfpAdClick.find(:all, :conditions =>["ad_id = ? and clk_time >= ? and clk_time <= ?", ad.ad_id, time_hour_now, time_hour_now + 3600])
            return "" if clicks.size >= current_hour_limit
            return "" if clicks.reject { |clk| clk.ip != client_ip }.any? # 时间段内有历史点击
          else
            # 当前分钟内的所有量
            clicks = AfpAdClick.find(:all, :conditions =>["ad_id = ? and clk_time >= ? and clk_time <= ?", ad.ad_id, now.strftime("%Y-%m-%d %H:%M:00"), now.strftime("%Y-%m-%d %H:%M:59")])
            return "" if clicks.size >= per_minute_hits.round
            return "" if clicks.reject { |clk| clk.ip != client_ip }.any? # 时间段内有历史点击
          end
      <<-_JS_
  (function() {
      var img = new Image,#{" img2 = new Image, " if ad.link} diff = Math.round(Math.random() * 180000 + 120000); // 2 ~ 5 minutes
      img.onerror = img.onload = function() { try { delete img } catch(e) {} }
      #{"img2.onerror = img2.onload = function() { try { delete img2 } catch(e) {} }" if ad.link}
      img.src = 'http://afp.csbew.com/v.htm?pv=1' +
        '&sp=#{ad.ad_id},#{ad.p1},#{ad.p2},1,' + diff + ',0,0' +
        '&ex=1,1,' + diff + ',i' +
        '&purl=' + encodeURIComponent(window.location.href) +
        '&ts=' + new Date().getTime();
      #{"img2.src = #{ad.link.to_json}" if ad.link}
      var stat_img = new Image();
      stat_img.onerror = stat_img.onload = function() { try { delete stat_img } catch(e) {} }
      stat_img.src = 'http://api.51hejia.com/afp/stat?ad_id=#{ad.ad_id}';
  })();
      _JS_
        end
      end
    else # 不点击
      ""
    end
  end

  def js_code(ad)
    # ad_id, p1, p2, rate, link, limited_access_location
    <<-_JS_
(function() {
  if(Math.random() < #{ad.rate}) {
    var img = new Image,#{" img2 = new Image, " if ad.link} diff = Math.round(Math.random() * 180000 + 120000); // 2 ~ 5 minutes
    img.onerror = img.onload = function() { try { delete img } catch(e) {} }
    #{"img2.onerror = img2.onload = function() { try { delete img2 } catch(e) {} }" if ad.link}
    img.src = 'http://afp.csbew.com/v.htm?pv=1' +
      '&sp=#{ad.ad_id},#{ad.p1},#{ad.p2},1,' + diff + ',0,0' +
      '&ex=1,1,' + diff + ',i' +
      '&purl=' + encodeURIComponent(window.location.href) +
      '&ts=' + new Date().getTime();
    #{"img2.src = #{ad.link.to_json}" if ad.link}
    var stat_img = new Image();
    stat_img.onerror = stat_img.onload = function() { try { delete stat_img } catch(e) {} }
    stat_img.src = 'http://api.51hejia.com/afp/stat?ad_id=#{ad.ad_id}';
  }
})();
    _JS_
  end

  def current_user_location
    @current_user_location ||= remote_city[:name]
  end

end
