class ArticleController < ApplicationController
  helper :rest

  #文章正文
  def show
    @is_preview = params[:article_id].to_s.include?("preview")
    return page_not_found! if @is_preview && !staff_logged_in?  #如果是预览状态并且没有权限

    @article_id = params[:article_id].to_s.sub("_preview","").to_i
    return page_not_found! unless @article_id > 0

    @page_num = params[:page]
    @first_tag_url = params[:first_tag_url]
    @city_name = remote_city_default[:name]
    #@city_name = "无锡"
    #@city_name = "海南"
    city_id = CITIES.invert[@city_name]
    @city_id = city_id
    @article = HejiaArticle.find(:first, :conditions => "id = #{@article_id} and STATE <> '-1'", :include => :first_tag)
    return page_not_found! if @article.nil? || @article.first_tag.nil? || (@article.STATE != 0 && !@is_preview)  #如果未发布且不是预览状态
=begin
    @jushang_cases = CACHE.fetch("jushang/cases/article:#{@article_id}/city_id:#{city_id}",1.hour) do
      HejiaCase.find(:all,
        :conditions => ["STATUS != '-100' and ISNEWCASE = 1 and ISZHUANGHUANG = '1' and TEMPLATE != 'room' and ISZHUANGHUANG='1' and DESIGNERID!=2291 and (deco_firms.city = ? or deco_firms.district = ?) ",city_id, city_id],
        :joins => "join deco_firms on HEJIA_CASE.COMPANYID = deco_firms.id",
        :order => "CREATEDATE desc", :limit=>4)
    end if ["zhuangxiu", "jushang","diban"].include?(@first_tag_url) && city_id
    @zhuangxiu_diaries = hejia_promotion_items(54215, :attributes => ['title','url','image_url','description'], :limit => 4) if !city_id && @first_tag_url == "zhuangxiu"
=end
    # 确保文章的访问地址正确
    if request.subdomains.join('.') != @article.first_tag.subdomain ||
        @first_tag_url != @article.first_tag.TAGURL ||
        @article.CREATETIME.strftime('%Y%m%d') != params[:create_time]
      return redirect_301_to(article_url(@article, :page => @page_num))
    end
    pages_cache_key = "key_publish_article_show_content_20090512_#{@article_id}"
    CACHE.delete(pages_cache_key) if @is_preview  #预览状态自动带有清除memecache缓存
    article_pages = CACHE.fetch(pages_cache_key, 1.month) do
      #会执行到该语句块，说明文章内容的缓存刚被清过，或者是新建的文章
      article_keywords_key = "key_publish_article_show_html_keywords_20100713_#{@article_id}"
      CACHE.delete(article_keywords_key) #一起清除该文章关键词缓存
      content = HejiaArticleContent.find(:first, :select=>"CONTENT", :conditions => ["id = ?", @article.CONTENTID])["CONTENT"] rescue ""
      if content == ""
        @ru = "http://www.51hejia.com?error=2"
        apages = []
      else
        content = content.gsub("[swf]", "<embed src='")
        content = content.gsub("[/swf]", "' quality='high' width='480' height='400' align='middle' allowScriptAccess='allways' mode='transparent' type='application/x-shockwave-flash'></embed>")
        content = content.gsub("src=\"/UserFiles/Image", "src=\"http://image.51hejia.com/UserFiles/Image")
        content = content.gsub("src=\"/images/binary", "src=\"http://image.51hejia.com/images/binary")
        apages = content.split("{==PAGE-BREAK==}")
        0.upto(apages.length-1) do |i|
          apages[i] = sub_inner_link(apages[i])
        end
      end
      apages
    end

    return page_not_found! if article_pages.blank?

    if params[:page] == 'all'
      @article_page = article_pages.join('')
    else
      @pages, @article_page = paginate_collection(article_pages, :page => params[:page])
    end
    
    # 相关日记#得到城市ID
    DecorationDiary and Picture
    room_id = case
    when @article.KEYWORD1 =~ /别墅/ ; 6
    when @article.KEYWORD1 =~ /别墅/ ; 1
    end
    if city_id
      @diaries = CACHE.fetch("article/decoration_diaries/article:#{@article_id}/city_id:#{city_id}/room_id:#{room_id}",1.hour) do
        DecorationDiary.published.city_num_is(city_id).room_is(room_id).is_good.
          find(:all,
          :select=>"decoration_diaries.id as id,decoration_diaries.title as title",
          :limit=>4)
      end    
    end
    @same_secondcategory_articles = HejiaArticle.same_secondcategory_articles(@article)

    @pinlei = ["youqituliao", "diban", "cizhuan", "buyi", "jiajuchanpin", "jiadian", "zhaomingpindao", "cainuan", "cainuanpindao",
      "chuguipindao", "weiyupindao", "kongtiao", "shuichuli"]
    @dianxing = ["chufang", "weiyu", "keting", "woshi", "shufang", "huayuanshenghuo", "beijingqiang", "ertongfang",
      "xiaohuxing", "ershoufang", "chaojizhufu", "bieshu"]
    @zhuangxiu = ["zhuangxiu"]
    @jushang = ["jushang"]
    @pinpaiku = ["pinpaiku"]
    if @dianxing.include?(@first_tag_url)
      @r1id = 54270; @r2id = 54265; @r3id = 54266; @m1id = 54267
    elsif @pinlei.include?(@first_tag_url)
      @r1id = 54269; @r2id = 54271; @r3id = 54216; @m1id = 54218
    elsif @zhuangxiu.include?(@first_tag_url)
      @r1id = 54268; @r2id = 54210; @r3id = 54215; @m1id = 54213
    end
    @key_huxing = HejiaIndexKeyword.find(:first, :conditions => ["id = 38422"]) #户型装修
    @key_fangjian = HejiaIndexKeyword.find(:first, :conditions => ["id = 37833"]) #房间装修
    @key_fengge = HejiaIndexKeyword.find(:first, :conditions => ["id = 3035"]) #装修风格
    @next_article = @article.next_article
    @xinwen = ["xinwen"]
    @maichang = ["maichang"]
    @jiaju = ["jiaju"]
    @article_type = '新闻'

    if @is_preview
      expires_now
    else
      headers.delete('Cache-Control') if headers['Cache-Control']
      headers["Expires"] = @article.headers_expire if @article  #设置HTML头部过期时间
    end

    if @first_tag_url != "xinwen" && @first_tag_rul != "pinpaiku"
      if city_id == 11910
        tiaojian = "city=11910"
      else
        tiaojian = "district=#{city_id}"
      end
      @tui_jian_gong_si = CACHE.fetch("api_firm:likes_style_firm:article:#{@article.ID}", RAILS_ENV != 'production' ? 0 : 5.days) do
        DecoFirm.find(:first,:conditions=>["#{tiaojian} and is_cooperation=1"],:order=>"rand()",:limit=>1)
      end if @first_tag_url == "zhuangxiu"
      @style_id = case @article.KEYWORD1
      when /现代|简约|日式|韩式|乐活|北欧|波普|ArtDeco|雅致|黑白|宜家|时尚|极简|可爱|温馨|浪漫|清风|梦幻|实用|典雅/ then 1
      when /田园|乡村|古典/ then 2
      when /欧式|美式|复古|怀旧|法式|英式|普罗旺斯|新古典|英伦|自然|托斯卡纳|意大利|简欧|宫廷|罗马|西班牙|传统|经典|加州/ then 3
      when /中式|禅意|藏式|园林|明清/ then 4
      when /地中海|希腊|爱琴海/ then 5
      when /混搭|东南亚|波西米亚|个性|另类/ then 6
      end
    end
    
    if !@ru.nil?
      redirect_to @ru
    elsif @jushang.include?(@first_tag_url)
      @article_type = '居尚'
  
      
      render :template => "article/show_jushang", :layout => "article_jushang"
    elsif @pinpaiku.include?(@first_tag_url)
      @article_type = '品牌库'
      @m1id = 54267
      render :template => "article/article", :layout => "article_pinpaiku"
    elsif @xinwen.include?(@first_tag_url)
      @m1id = 54267
      render :template => "article/article", :layout => "product_pricing_xinwen"
    elsif @maichang.include?(@first_tag_url)
      @article_type = '卖场'
      @m1id = 54267
      render :template => "article/article", :layout => "product_pricing_maichang"
    elsif @jiaju.include?(@first_tag_url)
      @article_type = '家居'
      @m1id = 54267
      render :template => "article/article", :layout => "product_pricing_jiaju"
    elsif @pinlei.include?(@first_tag_url)
      @article_type = '品类'
    elsif @dianxing.include?(@first_tag_url)
      @article_type = '典型'
    elsif @zhuangxiu.include?(@first_tag_url)
      @article_type = '装修资讯'
      render :template => "article/article", :layout => "article_zhuangxiu"
    else
      render :template => "article/product_pricing", :layout => "product_pricing"
    end
  end

  #文章列表 是这里么?
  def list
    #    @city_name = remote_city[:name]
    #    city_id = CITIES.invert[@city_name]
    #    DecorationDiary
    #    @like_diaries = CACHE.fetch("api_diary:likes_decoration_diaries:#{city_id}", RAILS_ENV != 'production' ? 0 : 1.hour) do
    #      DecorationDiary.published.city_num_is(city_id).is_good.
    #        find(:all,:include=>:master_picture,:select=>"decoration_diaries.id as id,decoration_diaries.title as title",:limit=>4)
    #    end
    @city_name = remote_city[:name]
    @city_id = CITIES.invert[@city_name].to_i
    @city_id ? @city_id : @city_id = 11910


    @first_tag_url = params[:first_tag_url]
    @date = params[:month]
    @tag_type = params[:tag_type]
    @format = params[:format]||"l"
    @tag_id = params[:tag_id]
    

    
    @page = params[:page]||1

    @perpage = @format == "h" ? 15 : 30

    cache_key = "articles/#{@tag_type}/#{@tag_id}/#{@date}/#{@format}/#{@page}"

    @results = CACHE.fetch(cache_key, 1.hours) do

      category = case @tag_type
      when 'f' then "FIRSTCATEGORY"
      when 's' then "SECONDCATEGORY"
      when 't' then "THIRDCATEGORY"
      end

      return page_not_found! if category.blank?


      conditions = ["#{category} = ? and STATE = '0'", @tag_id]
      if !@date.nil?
        if @date.include? "to"
          start_date, end_date = get_start_end_date2(*@date.split("to", 2))
        else
          start_date, end_date = get_start_end_date(@date)
        end
        conditions.first << " and CREATETIME > ? and CREATETIME < ?"
        (conditions << start_date) << end_date
      end

      HejiaArticle.paginate(
        :all,
        :select => "ID,FIRSTCATEGORY,CREATETIME,IMAGENAME,TITLE,SUMMARY,CREATETIME",
        :conditions => conditions,
        :order => "SECONDORDERID DESC, CREATETIME DESC",
        :per_page => @perpage,
        :page => @page
      )
    end

    if @first_tag_url == "jushang" && @tag_id.to_s == "42241"
      page_not_found!
    elsif @first_tag_url == "jushang"
      render :template => "article/list/list", :layout => "article_list_jushang"
    else
      render :template => "article/list/list", :layout => "article_list"
    end
  end
  
  def sub_inner_link(content)  #替换文章中的内链
    #    get_redirect_key_url("") if @redirect_key.nil?   #获得实例变量 @redirect_key
    #    for key in @redirect_key.keys
    #      content = content.sub(key, "<a href='#{@redirect_key[key]}' target='_blank' class='keywlinks'>#{key}</a>")
    #    end
    if @zss.nil?
      kw_mc = get_mc_kw("zq_mk",1,"zhuanqu_sorts")
      @zss = get_mc(kw_mc) do
        ZhuanquSort.find(:all,:select=>"id,board_id,sort_name,sub_kws",:conditions=>"is_delete=0").collect{ |r| [r.sort_name, r.board_id, r.sub_kws] }
      end
    end
    for zs in @zss
      kws = trim(zs[2]).split(" ") rescue []
      unless is_include_kws(content, kws)
        content = content.sub(zs[0], "<a href='http://#{ZHUANQU_BOARD_SPELL[zs[1]]}.51hejia.com/zq/#{zs[0]}/' title='点击访问《#{zs[0]}》专区' target='_blank' class='keywlinks'>#{zs[0]}</a>")
      end
    end
    return content
  end

  def is_include_kws(content, kws)  #判断文本里是否包含“一组关键词数组里的某一个关键词”
    rv = false
    unless kws.length == 0
      for kw in kws
        rv = true if content.include?(kw)
      end
    end
    return rv
  end

  def change_memcache_key_prefix  #修改key_name相关缓存关键字前缀
    key_name = params[:key_name]
    if trim(key_name).length == 0
      @rv = "操作错误：参数不足！"
    else
      old_key = mc(key_name)
      if old_key.nil?
        new_key = get_memcache_key_prefix(key_name)
      else
        t = old_key.gsub(key_name, "").to_i
        if t == 9999
          t = 1
        else
          t += 1
        end
        new_key = "#{key_name}#{t}"
      end
      mc(key_name, new_key)
      @rv = "操作成功：缓存关键字 #{key_name} 的值已修改为 #{new_key}"
    end
    myrender(@rv, @ru)
  end

  private

  def article_url(article, options = nil)
    url = 'http://%s.51hejia.com%s/%s/%s/%d' % [
      article.first_tag.subdomain,
      request.port_string,
      article.first_tag.TAGURL,
      article.CREATETIME.strftime('%Y%m%d'),
      article.id
    ]
    url << "-#{options[:page]}" if options and options[:page].to_i > 0
    url
  end

end
