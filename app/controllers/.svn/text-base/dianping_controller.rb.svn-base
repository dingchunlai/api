class DianpingController < DecoController
  
#  before_filter :discard_this_controller
  #  require "redis"
  $title_id = 'dp'
  #最新评论
  def index
    this_city =  cookies[:user_city]
    city_name = TAGURLS[this_city.to_i]
    url = "http://z.#{city_name}.51hejia.com/zhuangxiugongsi"
    redirect_301_to url
  end
  
  #评论列表页
  def indexnew
    this_city =  cookies[:user_city]
    city_name = TAGURLS[this_city.to_i]
    url = "http://z.#{city_name}.51hejia.com/zhuangxiugongsi"
    redirect_301_to url
  end
  
  def removekey
    CACHE.set(params[:key], nil)           
  end

  # 某公司中的评论
  # 基于以前旧的链接，跳转指向新的公司地址
  def companycomment
    id = params[:firm_id] || params[:id]
    url = get_firm_path id
    redirect_301_to url
  end
  
  #评论终端
  def show
    @id = params[:id]
    @commont = DecoReview.get_review_by_id(@id)
    @replytype = params[:replytype]
    @company = DecoFirm.getfirm(@commont.company_id)
    url = get_firm_path @company
    redirect_301_to url
    #所有回应，不包括举报
#    @replys = DecoReply.getreplies(@id,'1')
#    @graph = open_flash_chart_object(112,60, "/demo/pie?vs=#{@company.verysatisfied}&s=#{@company.satisfied}&us=#{@company.unsatisfied}", true, '/')
  end
  
  #回复/举报
  def addreply
    reply = DecoReply.new
    reply.formid = HUIFU_ID
    reply.cdate = Time.now
    reply.udate = Time.now
    reply.userip = request.remote_ip
    reply.review_id = params[:reviewid]
    reply.replytype = params[:replytype]
    reply.user_id = current_user.USERBBSID.to_s

    if current_user.USERBBSNAME
      reply.username = current_user.USERBBSNAME 
    else
      reply.username = current_user.USERNAME 
    end
    
    reply.userurl = "http://member.51hejia.com/images/headimg/#{rand(100).to_s}.gif" 
      
    reply.content = params[:content]
    reply.save
    
    review = DecoReview.find(params[:reviewid])
    if params[:replytype] == '1'
      review.response_num = review.response_num.to_i + 1
    elsif params[:replytype] == '2'
      review.report_num = review.report_num.to_i + 1
    end
    review.save
    
    redirect_to :action => "show",:id => params[:reviewid]
  end
  
  
  #优惠点评回复
  def add_youhuiquan_reply
    common_reply(params[:reviewid],params[:replytype],params[:content],'1')
  end
  #报价单回复
  def add_quotation_reply
    common_reply(params[:reviewid],params[:replytype],params[:content],'2')
  end
  #回复公共部分
  def common_reply(reviewid,replytype,content,type)
    reply = DecoReply.new
    reply.formid = HUIFU_ID
    reply.cdate = Time.now
    reply.udate = Time.now
    reply.userip = request.remote_ip
    reply.review_id = reviewid
    reply.replytype = replytype
    reply.user_id = current_user.USERBBSID.to_s

    if current_user.USERBBSNAME
      reply.username = current_user.USERBBSNAME 
    else
      reply.username = current_user.USERNAME 
    end

    reply.userurl = "http://member.51hejia.com/images/headimg/#{rand(100).to_s}.gif" 

    reply.content = content
    if type.to_i == 1
      reply.type = '1'
      update_reply_date(params[:reviewid])
      reply.save
      CACHE.set("zhaozhuangxiu_event_2009_12_01_event_coupon_list_page_by____#{Time.now.strftime('%Y%m%d%H')}_",nil)
      redirect_to :controller => "events", :action=>"coupon", :id => params[:reviewid]
    else
      reply.type = '2'
      reply.save
      redirect_to :controller => "events", :action=>"quotation", :id => params[:reviewid]
    end
  end
  
  #删除回应
  def deletereply
    reply = DecoReply.find(params[:replyid])
    
    review = DecoReview.find(reply.review_id)
    review.response_num = review.response_num.to_i - 1
    
    
    DecoReply.delete(params[:replyid])
    review.save
    
    redirect_to :action => 'show',:id => params[:reviewid]
  end
  
  #添加评论
  def new
    @companyid = params[:id]
    @company = DecoFirm.find(@companyid)
    
    if request.post?
      review = DecoReview.new
      review.company_id = @companyid
      review.user_id = current_user.USERBBSID.to_s
      review.design_score = params[:design_score]
      review.budget_score = params[:budget_score]
      review.construction_score = params[:construction_score]
      review.service_score = params[:service_score]
      review.complex_score = params[:complex_score]
      review.title = params[:title]
      review.content = params[:content]
      review.area = params[:area]
      review.address = params[:address]
      review.phone = params[:phone]
      review.review_type = '1'
      review.flower_num = '0'
      review.response_num = '0'
      review.report_num = '0'
      review.formid = PINGLUN_ID
      review.userip = request.remote_ip
      review.cdate = Time.now
      review.udate = Time.now
      review.price = params[:price]
      review.style = params[:style]
      review.method = params[:method]

      if current_user.USERBBSNAME
        review.username = current_user.USERBBSNAME 
      else
        review.username = current_user.USERNAME 
      end
      review.c18 = review.username  #后台查看
      
      review.userurl = "http://member.51hejia.com/images/headimg/#{rand(100).to_s}.gif" 
      review.c9 = '1' if user.ischeck == 1
      
      review.save
      @message = "1"
    end
    render :layout => 'none.rhtml'
  end
  
  #鲜花
  def flower
    if review = DecoReview.cached_dianping(params[:reviewid])
      p review.flower_num
      review.flower_num = review.flower_num.to_i + 1
      DecoReview.update_all({:c10 => review.flower_num}, :id => review.id)
      DecoReview.cached_dianping review # 更新缓存中的对象
      @number = review.flower_num
    end

    render :partial => "flower1"
  end

  #鲜花
  def flower3
    if review = DecoReview.cached_dianping(params[:reviewid])
      review.egg += 1
      DecoReview.update_all({:c31 => review.egg}, :id => review.id)
      DecoReview.cached_dianping review # 更新缓存中的对象
      @number = review.egg
    end

    render :partial => "flower1"
  end  
  
  #列表页鲜花
  def flower2
    review = DecoReview.find(params[:reviewid])
    review.flower_num = review.flower_num.to_i+1
    review.save

    @number = review.flower_num
    
    render :partial => "flower2"
  end
  
  def graph_code
    data = []
    3.times do |t|
      data << rand(10) + 5
    end
    
    g = Graph.new
    g.pie(60, '#505050', '{font-size: 7px; color: #404040;}')
    g.pie_values(data, %w(IE FireFox Opera))
    g.pie_slice_colors(%w(#FF6600 #000000 #960096))
    g.set_tool_tip("#val#%")
    g.set_bg_color('#ffefe0')
    #    g.title("Pie Chart", '{font-size:18px; color: #d01f3c}' )
    render :text => g.render
    
  end
  
  def editnew
    if user_logged_in?
      @userid = current_user.USERBBSID
      @user = current_user
      
      if @user.USERBBSNAME
        @name = @user.USERBBSNAME 
      else
        @name = @user.USERNAME 
      end

      @sex = @user.USERBBSSEX
      @headimage = @user.HEADIMG

      id = params[:id]
      @review = DecoReview.find(id)
      @company = DecoFirm.find(@review.company_id)
      if request.post?
        @review.design_score = params[:design_score]
        @review.budget_score = params[:budget_score]
        @review.construction_score = params[:construction_score]
        @review.service_score = params[:service_score]
        @review.complex_score = params[:complex_score]
        @review.title = params[:title]
        @review.content = params[:content]
        @review.area = params[:area]
        @review.address = params[:address]
        @review.phone = params[:phone]
        @review.udate = Time.now
        @review.price = params[:price]
        @review.style = params[:style]
        @review.method = params[:method]
        @review.stage = params[:stage]
        @review.room = params[:room]
        @review.photourl = getimagepath
        @review.update_attributes(params[:review])
        session[:item]=nil
        rt = alert("修改成功！请继续操作！")
        render :text => rt + js(top_load("http://member.51hejia.com/member/user_note_list"))
      end
    else
      redirect_to "http://z.51hejia.com"
    end
  end
  
  def continuenew
    if user_logged_in?
      @userid = current_user.USERBBSID
      @user = current_user
      
      if @user.USERBBSNAME
        @name = @user.USERBBSNAME 
      else
        @name = @user.USERNAME 
      end
      @sex = @user.USERBBSSEX
      @headimage = @user.HEADIMG

      @main_id = params[:main_id]
      @review = DecoReview.find(@main_id)
      @company = DecoFirm.find(@review.company_id)
      @message = params[:message]
      
      if request.post?
        hash = {
            'company_id' => @review.company_id,
            'title' => params[:title],
            'content' => params[:content],
            'design_score' => params[:design_score],
            'budget_score' => params[:budget_score],
            'construction_score' => params[:construction_score],
            'service_score' => params[:service_score],
            'area' => params[:area],
            'address' => params[:address],
            'review_type' => 1,
            'price' => params[:price],
            'style' => params[:style],
            'method' => params[:method],
            'remark' => params[:remark],
            'review_type2' => 0,
            'main_id' => @main_id,
            'stage' => params[:stage],
            'room' => params[:room]
        }  
        complex_score = params[:design_score].to_i+params[:budget_score].to_i+params[:construction_score].to_i+params[:service_score].to_i
        complex_score = complex_score.to_f
        
        review = DecoReview.new(hash)
        review.complex_score = complex_score
        review.formid = @review.formid
        review.userip = request.remote_ip
        review.cdate = getnow
        review.udate = getnow
        review.user_id = @review.user_id
        review.username = @review.username
        review.userurl = @review.userurl
        #        review.author = @review.author
        review.c9 = '1'
        review.status = 0
        review.city_id = @review.city_id
        review.district_id = @review.district_id
        review.photourl = getimagepath
        review.save
        session[:item]=nil
        redirect_to :action => 'dianping_list' ,:message=>"1"
      end
    else
      redirect_to "http://z.51hejia.com"
    end
  end
  
  def shownew
    @userid = current_user.USERBBSID
    id = params[:id]
    @review = DecoReview.get_review_by_id(id)
    if !@review.main_id.nil?&&@review.main_id.to_i!=0
      @main_id = @review.main_id
    else
      @main_id = id
    end
    @mylist = DecoReview.get_list_by_id(id)
    @company = DecoFirm.find(@review.company_id)
    @nextdianping = DecoReview.get_next_dianping(id,@company.id)
    @first = DecoReview.get_start_dianping(@company.id)
    key = "zhaozhuangxiu_dianping_shownew1_#{@main_id}_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      @list = DecoReview.find(:all,:conditions => "id = #{@main_id} or c25 = #{@main_id}",:order => "cdate asc,id asc" )
      CACHE.set(key,@list)
    else
      @list = CACHE.get(key)
    end
    pages = nil
    if @list.size>0
      1.upto(@list.size) do |i|
        puts "==================="
        puts @list[i-1].id
        puts id
        puts "================"
        if @list[i-1].id.to_s == id
          pages = i
        end
        puts pages
      end
    end
    @reviewlist = @list.paginate :page => pages, :per_page => 1
    #    pages = params[:page]
    if !pages.nil?&&pages.to_i>1
      @prevpage = pages.to_i-1
      @prev = @list.paginate :page => @prevpage, :per_page => 1
    else
      @prev = nil
    end
    if pages.to_i==@reviewlist.total_entries.to_i
      @nextcase = nil
    else
      if pages.to_i==0
        pages = 1
      end
      @nextpage = pages.to_i+1
      puts "======================="
      puts @nextpage
      @nextcase = @list.paginate :page => @nextpage, :per_page => 1
    end
  end
  
  def dianping_list
    if user_logged_in?
      @message = params[:message]
      @userid = current_user.USERBBSID
      @user = current_user
      if @user.USERBBSNAME
        @name = @user.USERBBSNAME 
      else
        @name = @user.USERNAME 
      end
      @sex = @user.USERBBSSEX
      @headimage = @user.HEADIMG
      @results = DecoReview.find(:all,:select=>"id,c8,c10,c11,cdate,c3,c4,c5,c6,c7,c25,c30,c31",:conditions=>"formid = '#{PINGLUN_ID}' and c2=#{@userid} and status != '-1'",:order => "id desc")      
      @result = @results.paginate :page => params[:page], :per_page => 6
    else
      redirect_to "http://z.51hejia.com"
    end
  end
  
  def dianping_delete
    if user_logged_in?
      ids = params[:id]
      @userid = current_user.USERBBSID
      @user = current_user
      DecoReview.update_all("status = '-1'", "id in ( #{ids} )")
      redirect_to :action => 'dianping_list'
    else
      redirect_to "http://z.51hejia.com"
    end
    
  end
  #回复
  def addreplynew
    reply = DecoReply.new
    reply.formid = HUIFU_ID
    reply.cdate = Time.now
    reply.udate = Time.now
    reply.userip = request.remote_ip
    reply.review_id = params[:reviewid]
    reply.replytype = params[:replytype]
    reply.user_id = current_user.USERBBSID.to_s

    if current_user.USERBBSNAME
      reply.username = current_user.USERBBSNAME 
    else
      reply.username = current_user.USERNAME 
    end
      
      reply.userurl = "http://member.51hejia.com/images/headimg/#{rand(100).to_s}.gif" 
      
    reply.content = params[:content]
    reply.save
    
    review = DecoReview.find(params[:reviewid])
    if params[:replytype] == '1'
      review.response_num = review.response_num.to_i + 1
    elsif params[:replytype] == '2'
      review.report_num = review.report_num.to_i + 1
    end
    review.save
    
    redirect_to :action => 'shownew',:id => params[:reviewid]
  end
  
  #臭鸡蛋
  def badegg
    review = DecoReview.find(params[:reviewid])
    review.egg = review.egg.to_i+1
    review.save
    
    @number = review.egg
    
    render :partial => "badegg"
  end
  
  def getimagepath
    path = session[:item]
    return path
  end
  
  def company
    @cities = get_cities
    @name = params[:name]
    @city = params[:citycity]
    @area = params[:area]
    if !@city.nil?&&@city!=0
      @arealist = get_areas2(@city)
    else
      @arealist = get_areas2(11910)
      @city = 11910
    end
    decofirm = DecoFirm.get_deco_firms(@name, @city,@area)
    @decofirms = decofirm.paginate :page => params[:page], :per_page => 12
    render :layout => 'none.rhtml'
  end
  
  #执行查询某省市下的区县信息
  def select_city_area
    @area = get_areas2(params[:cityid])
    render :partial => "select_city_area"
  end
  
  #根据省市编号取得各省市下的地区域Hash
  def get_areas2(cityid) 
    if cityid.to_i == 0
      areas = Hash.new
      return areas    
    end
    key = "zhaozhuangxiu_area_#{cityid}_Time.now.strftime('%Y%m%d')"
    DecoReply
    if CACHE.get(key).nil?
      as = DecoReply.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = #{cityid}")
      areas = Hash.new
      as.each do |a|
        areas[a.tagid.to_i] = a.tagname
      end
      CACHE.set(key,areas)
    else
      areas = CACHE.get(key)
    end
    return areas
  end
  
  #取得所有省的hash
  def get_cities
    key = "zhaozhuangxiu_cities_hash_Time.now.strftime('%Y%m%d')"
    DecoReply
    if CACHE.get(key).nil?
      cs = DecoReply.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 15000")
      citys = Hash.new
      cs.each do |a|
        citys[a.tagid.to_i] = a.tagname
      end
      CACHE.set(key,citys)
    else
      citys = CACHE.get(key)
    end
    return citys
  end
  
  def dianping_series
    @userid = current_user.USERBBSID
    id = params[:id]
    @review = DecoReview.get_review_by_id(id)
    if !@review.main_id.nil?&&@review.main_id.to_i!=0
      @main_id = @review.main_id
    else
      @main_id = id
    end
    @mylist = DecoReview.get_list_by_id(id)
    @company = DecoFirm.find(@review.company_id)
    key = "zhaozhuangxiu_dianping_dianping_series_#{@main_id}_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      @list = DecoReview.find(:all,:conditions => "id = #{@main_id} or c25 = #{@main_id}",:order => "cdate asc,id asc" )
      CACHE.set(key,@list)
    else
      @list = CACHE.get(key)
    end
    ids = DecoReview.find(:all,:select=>"id",:conditions => "id = #{@main_id} or c25 = #{@main_id}").collect{|t| t.id}.join(',')
    @rids=""
    if !ids.nil?
      @rids+=ids.to_s
    end
    @result = @list.paginate :page => params[:page], :per_page =>5
  end
  
  
  #回复1
  def addreplynew1
    reply = DecoReply.new
    reply.formid = HUIFU_ID
    reply.cdate = Time.now
    reply.udate = Time.now
    reply.userip = request.remote_ip
    reply.review_id = params[:reviewid]
    reply.replytype = params[:replytype]
    reply.user_id = current_user.USERBBSID.to_s

    if current_user.USERBBSNAME
      reply.username = current_user.USERBBSNAME 
    else
      reply.username = current_user.USERNAME 
    end
    
    reply.userurl = "http://member.51hejia.com/images/headimg/#{rand(100).to_s}.gif" 
      
    reply.content = params[:content]
    reply.save
    
    review = DecoReview.find(params[:reviewid])
    if params[:replytype] == '1'
      review.response_num = review.response_num.to_i + 1
    elsif params[:replytype] == '2'
      review.report_num = review.report_num.to_i + 1
    end
    review.save
    
    redirect_to :action => 'shownew1',:id => params[:reviewid]
  end

  def shownew1
    @id = params[:id]
    @commont = DecoReview.get_review_by_id(@id)
    @replytype = params[:replytype]
    @company = DecoFirm.getfirm(@commont.company_id)
    url = get_firm_path @company
    redirect_301_to url
  end
  
  private 
  def discard_this_controller
    page_not_found!
  end
end

def update_reply_date(id)
  DecoEvent.update_all({:reply_date => Time.now}, :id => id)
end
