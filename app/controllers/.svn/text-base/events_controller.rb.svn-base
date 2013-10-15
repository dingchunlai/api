class EventsController < DecoController
  include DecoHelper
  before_filter :domain_validate, :only => :coupon
  before_filter FormTokenFilter, :only => :coupon
    
  def domain_validate
    @firm = validates_firm_with_subdomain(:cid) do |firm|
      headers["Status"] = "301 Moved Permanently"
      redirect_to gen_firm_city_event(firm.id, params[:id])
    end    
  end
  private :domain_validate

  $title_id = 'cx'
  def index
    #    key = "zhaozhuangxiu_event_index_#{Time.now.strftime('%Y%m%d%H')}"
    #    if !params[:page].nil?
    #      key+="_"+params[:page]
    #    end
    #    if CACHE.get(key).nil?
    #      @events = DecoEvent.paginate :page => params[:page], :per_page => 10, :order => "ends_at desc, created_at desc"
    #      CACHE.set(key, @events)
    #    else
    #      @events = CACHE.get(key)
    #    end
    redirect_to "/zhuangxiuhuodong"
  end

  def show
    id = params[:id]
    enventskey = "zhaozhuangxiu_event_keys_#{id}_#{Time.now.strftime('%Y%m%d%H')}"
    registerskey = "zhaozhuangxiu_event_key_#{Time.now.strftime('%Y%m%d%H')}_#{id}_1"
    going_eventskey = "zhaozhuangxiu_going_events_key_#{Time.now.strftime('%Y%m%d%H')}"
    coming_eventskey = "zhaozhuangxiu_coming_events_key_#{Time.now.strftime('%Y%m%d%H')}"
    deco_firmskey = "zhaozhuangxiu_deco_firms_deco_#{id}_key_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(enventskey).nil?
      @event = DecoEvent.find(params[:id])
      CACHE.set(enventskey, @event)
    else
      @event = CACHE.get(enventskey)
    end
    if CACHE.get(deco_firmskey).nil?
      @firm = @event.firms[0]
      CACHE.set(deco_firmskey, @firm)
    else
      @firm = CACHE.get(deco_firmskey)
    end
    @register = DecoRegister.new
    if CACHE.get(registerskey).nil?
      @registers = @event.registers.find(:all, :limit => 10, :order => "created_at desc")
      CACHE.set(registerskey, @registers)
    else
      @registers = CACHE.get(registerskey)
    end
    #    @registers = @event.registers.find(:all, :limit => 10, :order => "created_at desc")
    if CACHE.get(going_eventskey).nil?
      @going_events = DecoEvent.find(:all, :limit => 2, :conditions => ["starts_at < ?", Time.now], :order => "created_at desc")
      CACHE.set(going_eventskey, @going_events)
    else
      @going_events = CACHE.get(going_eventskey)
    end
    
    if CACHE.get(coming_eventskey).nil?
      @coming_events = DecoEvent.find(:all, :limit => 2, :conditions => ["starts_at > ?", Time.now], :order => "created_at desc")
      CACHE.set(coming_eventskey, @coming_events)
    else
      @coming_events = CACHE.get(coming_eventskey)
    end

    if @event.lat && @event.lng
      @map = GoogleMap::Map.new
      @map.controls = [ :zoom ]
      @map.zoom = 15
      @map.markers << GoogleMap::Marker.new(  :map => @map,
        :lat => @event.lat,
        :lng => @event.lng)
    end
  end

  def register
    @event = DecoEvent.find(params[:id])
    @register = @event.registers.build(params[:register])
    if @register.save
      flash[:notice] = "报名成功！"
      DecoEvent.update_all "registers_count = #{@event.registers_count + 1}", :id => @event.id
      redirect_to event_url(@event)
    end
  end
  
  # 优惠券终端页
  # 20100428毛秋云修改 
  def coupon
    id = params[:id]
    page = params[:page] || 1
    # 获取优惠券对象
    @event = CACHE.fetch("events/#{id}", RAILS_ENV == 'production' ? 1.hour : 1) do
      DecoEvent.find_by_id id
    end
    # 得到公司编号
    firm_id = "zhaozhuangxiu_events_to_company_id_#{id}_#{Time.now.strftime('%Y%m%d')}"
    if CACHE.get(firm_id).nil?
      if @event.firms
        if @event.firms.size > 0
          @firm_id = @event.firms[0].id.to_s
        else
          @firm_id = 0
        end
      end
      CACHE.set(firm_id, @firm_id)
    else
      @firm_id = CACHE.get(firm_id)
    end
    page_not_found! if@firm_id != params[:cid]
    # 取得优惠券评论信息
    @coupon = @event.remarks.paginate :page => page, :per_page =>10
    
    # 取得同省市下的其他优惠券信息
    @regional = CACHE.fetch("coupon/#{id}/same_district",3.hours) do
      firms_id = DecoFirm.find(:all, 
        :select =>"id",
        :conditions => ["district = ?",DecoEvent.find(id).firms[0].district]).map{|r| r.id} #当前区域所有公司ID（数组,上海按区划分，其它城市按市划分）
      #获得当前区域内所有公司的未结束的优惠券信息
      DecoEvent.find(:all,
        :joins => "deco_events join deco_events_firms on deco_events.id = deco_events_firms.event_id",
        :conditions => [" deco_events_firms.firm_id in (?) and deco_events.ends_at > ?", firms_id,Time.now],
        :limit => 10
      )
    end
  end
  
  #报价单终端页
  def quotation
    id = params[:id]
    @quot_peply = DecoReply.get_events_reply_byc1_1_and_c34_count(params[:page],id,'1','2')
    quotation_id = "zhaozhuangxiu_2009_11_27_quotation_last_page_by_#{id}_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(quotation_id).nil?
      @quotation = DecoQuotation.find(:first, :conditions => ["id = ?",id])
      CACHE.set(quotation_id, @regional)
    else
      @quotation = CACHE.get(quotation_id)
    end
    firm_id = "zhaozhuangxiu_2009_11_27_quotation_to_company_id_#{id}_#{Time.now.strftime('%Y%m%d')}"
    if CACHE.get(firm_id).nil?
      if @quotation.firms
        if @quotation.firms.size > 0
          @firm_id = @quotation.firms[0].id.to_s
        else
          @firm_id = 0
        end
      end
      CACHE.set(firm_id, @firm_id)
    else
      @firm_id = CACHE.get(firm_id)
    end
  end
  #返回排序条件
  def coupon_find_add_order(order)
    orderstr = ""
    if order
      puts order.to_s
      if order.to_s == '1'
        orderstr="ends_at desc"
        @order = "1"
      elsif order.to_s == '2'
        orderstr="created_at desc"
        @order = "2"
      else
        orderstr = "reply_date desc"
        @order = "0"
      end
    else
      orderstr = "reply_date desc"
      @order = "0"
    end 
    return orderstr
  end
  #返回查询条件
  def coupon_find_add_conditions(quyu1,type2)
    conditions = []
    conditions << "city like '%上海%'"
    @quyu = quyu1
    types = type2
    if @quyu.to_i != 0
      quyuname = DISTRICTS[@quyu.to_i].to_s
      conditions << "district like '%#{quyuname}%'"
    end
    if types
      if @quyu.to_i == 0
        @quyu = 0
      end
      if types.to_s == "12"
        @types = "12"
        conditions << " types = '12' "
      elsif types.to_s == "13"
        @types = "13"
        conditions << " types = '13' "
      else
        @types = "11"
        conditions << " (types = '11' or  types is null) "
      end
    else
      @types = "11"
      @quyu = "0"
      conditions << " (types = '11' or  types is null) "
    end
    return conditions
  end
end
