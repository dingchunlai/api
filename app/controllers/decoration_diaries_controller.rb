# encoding UTF-8
# 日记终端页面
# decoration_diaries MODEL 
# @time 2010/5/18
# @author毛秋云
# params[:nid]       # 日记编号
# params[:fid]       # 公司编号

class DecorationDiariesController < DecoController

  before_filter :city_validate, :only => [:index]
  before_filter :validate_note,  :only => [:index]            # 创建日记对象并验证
  before_filter :load_other_object,  :only => [:index]               # 创建除日记对象之外的其他元素信息对象
  before_filter :get_browsed_diaries, :only => [:index]
  before_filter :set_browsed_diaries, :only => [:index]
  before_filter :get_browsed_firms, :only => [:index] 
  #before_filter FormTokenFilter, :only => [:index,:new_diray_remark]
  
  
  def index
    @ad_space_base = "装修日记-终端页"
    render :partial => "/decoration_diaries/diary_posts", :locals => { :diary => @diary, :page => @page, :diary_posts => @diary_posts } if params[:page]
  end

  #提交日记评论
  def new_diray_remark
    remark = Remark.new(params[:remark])
    remark.ip=request.remote_ip
    if remark.save
      if remark.parent_id
        remark_reply = Remark.find_by_id remark.parent_id
        remark_reply.update_attribute(:is_replied, true) if !remark_reply.is_replied
        remark = remark_reply
      end
      diary_post = DecorationDiaryPost.find_by_id remark.resource_id
      if params[:remark][:resource_type] && params[:remark][:resource_id]
        render :partial => "/decoration_diaries/diary_post_remarks", :locals => { :diary_post => diary_post }
      else
        render :partial => "/decoration_diaries/diary_post_remark_replies", :locals => { :remark => remark }
      end
    else
      if params[:remark][:resource_type] && params[:remark][:resource_id]
        diary_post = DecorationDiaryPost.find params[:remark][:resource_id]
        flash[:error] = "您在一分钟内，不能频繁发表多次评论!"
        render :partial => "/decoration_diaries/diary_post_remarks", :locals => { :diary_post => diary_post }
      else
        remark = Remark.find params[:remark][:parent_id]
        flash[:notice] = "您在一分钟内，不能频繁回复多次评论!"
        render :partial => "/decoration_diaries/diary_post_remark_replies", :locals => { :remark => remark }
      end
    end
  end

  #获得修改前的路由，转向新的路由
  def turn_to
    fid = params[:fid]
    nid = params[:nid]
    url ='/gs-'+fid+'/zhuangxiugushi/'+nid
    redirect_301_to url
  end

  # 分页查询某个公司的日记信息
  def paginator
    firm = DecoFirm.getfirm params[:id]
    @diaries = firm.decoration_diaries.paginate :page => params[:page], :per_page => 5
    render :partial => "/firms/diaries"
  end
  
  #顶，踩用IP做限制
  def verify_ip
    id = params[:id]
    ip = request.remote_ip.to_s
    result = REDIS_DB.get("diary:verify:ip:#{ip}:#{id}").nil? ? true : false
    render :json => {:result => result}.to_json
  end

  #投票
  def to_vote_for_me
    ip = request.remote_ip.to_s
    if diary = DecorationDiary.cached_decoration_diaries(params[:reviewid])
      key = "diary/show/#{params[:reviewid]}/toupiao"
      REDIS_DB.set key, (REDIS_DB.get key).to_i + 1
      DecorationDiary.cached_decoration_diaries diary # 更新缓存中的对象
      REDIS_DB.setex "diary:verify:ip:#{ip}:#{params[:reviewid]}", 24.hours , 1
    end
    render :nothing => true
  end
  
  #日记鲜花
  def flower
    ip = request.remote_ip.to_s
    if diary = DecorationDiary.cached_decoration_diaries(params[:reviewid])
      diary.update_attribute :useful_num , diary.useful_num.to_i + 1
      DecorationDiary.cached_decoration_diaries diary # 更新缓存中的对象
      REDIS_DB.setex "diary:verify:ip:#{ip}:#{params[:reviewid]}", 24.hours , 1
    end
    render :nothing => true
  end

  #日记鸡蛋
  def egg
    ip = request.remote_ip.to_s
    if diary = DecorationDiary.cached_decoration_diaries(params[:reviewid])
      diary.update_attribute :useless_num, diary.useless_num.to_i + 1
      DecorationDiary.cached_decoration_diaries diary # 更新缓存中的对象
      REDIS_DB.setex "diary:verify:ip:#{ip}:#{params[:reviewid]}", 24.hours , 1
    end
    render :nothing => true
  end  
  #日记留言分页
  def remaks_page
    @diary_id = params[:id]
    @deco_name = DecorationDiary.getNote(@diary_id).deco_firm.name_abbr
    page = params[:page]
    page = 1 if page.nil?
    @remarks= DecorationDiary.remarks_paginate(@diary_id,page)
     
    render :partial => "/decoration_diaries/remarks"
  end

  def sort_diary_body
    @nid = params[:nid]       # 日记编号
    @fid = params[:fid]       # 公司编号
    @page = params[:page]
    diary = DecorationDiary.find_by_id @nid
    @order = params[:order] if params[:order] && (params[:order].to_i == 1 || params[:order].to_i == 2) #日记排序
    order = @order && @order.to_i == 2 ? "updated_at desc" : "updated_at asc"
    @diary_posts = diary.verified_diary_posts.paginate :page => params[:page], :per_page => 15, :order => order
    render :partial => "/decoration_diaries/diary_posts", :locals => { :diary => diary, :page => @page, :diary_posts => @diary_posts }
  end
  
  #更新日记缓存
  def get_diary
    CACHE.fetch("DecorationDiary/#{@fid}/#{@nid }", 6.hours) do
      
    end
  end
  
  
  # 验证该日记是否属于该公司和日记是否对应
  private
  def validate_note
    city =  params["city"] # 当前城市
    @nid = params[:nid]       # 日记编号
    @fid = params[:fid]       # 公司编号
    key = "diary/show/#{@nid}/toupiao"
    REDIS_DB.set key, '0' unless REDIS_DB.get key
    nid = CACHE.fetch("DecorationDiary/#{@fid}/#{@nid}/#{city}", RAILS_ENV == 'development' ? 0 : 6.hours) do
      city_sql = city.to_i == 11910 ? "city = 11910" : "district = #{city.to_i}"
      if params[:preview] && params[:preview] == "true"
        diary = DecorationDiary.find(:first,
          :joins => "a,deco_firms b",
          :conditions => ["a.id = ? and a.deco_firm_id = ? and a.deco_firm_id = b.id and b.#{city_sql}", @nid.to_i, @fid.to_i])
      else
        diary = DecorationDiary.find(:first,
          :joins => "a,deco_firms b",
          :conditions => ["a.id = ? and a.deco_firm_id = ? and a.status != -1 and a.deco_firm_id = b.id and b.#{city_sql}", @nid.to_i, @fid.to_i])
      end
      if diary.nil?
        0
      else
        @nid.to_i
      end
    end
    @page = params[:page] ? params[:page] : 1
    @order = params[:order] if params[:order] && (params[:order].to_i == 1 || params[:order].to_i == 2) #日记排序
    @order = params[:order] ? params[:order] : 1
    order = @order && @order.to_i == 2 ? "updated_at desc" : "updated_at asc"
    if nid != 0
      @diary = DecorationDiary.getNote(nid)
      key="decoration_diaries/#{@diary.id}/pv"
      REDIS_DB.set key, @diary.pv unless REDIS_DB.get key
      @diary_posts = @diary.verified_diary_posts.paginate :page => params[:page], :per_page => 15, :order => order
      true
    else
      page_not_found!
      false
    end
  end
  
  # 返回城市信息
  def return_firm_info
    @city = nil 
    city_id = cookies["user_city"].to_i
    if cookies["user_city"] && cookies["user_city"].to_i > 0
      @city = CaseTag.find(city_id.to_i)
    else
      @city = CaseTag.find(11910)
    end
  end
  
  # 加载日记信息页的其余信息

  def load_other_object
    @city_id = get_and_save_city(nil, request.remote_ip)
    @username = @diary.api_user
    @firm_id = @diary.deco_firm_id
    @city = return_firm_info
    #得到当前日记的留言
    page = 1
    #@remarks= DecorationDiary.remarks_paginate(@diary.id,page)
  end

  # 保存浏览过的日记记录
  def set_browsed_diaries
    id = params[:nid]
    return unless id
    id = id.to_i
    browsed_diaries = (cookies[:browsed_diaries] || '').split(',').map(&:to_i)
    browsed_diaries.delete id
    browsed_diaries.unshift id
    browsed_diaries = browsed_diaries[0...8] # 保存最新的8次浏览记录
    cookies[:browsed_diaries] = browsed_diaries.join(',')
    true
  end
end
