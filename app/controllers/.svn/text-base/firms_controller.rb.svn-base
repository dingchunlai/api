# -- encoding: utf-8 --

# @code firms_controller
class FirmsController < DecoController
  include DecoHelper
  before_filter :domain_validate,:only => :show
  before_filter :get_browsed_firms, :only => [:show, :index]
  before_filter :set_browsed_firms, :only => [:show]
  before_filter FormTokenFilter, :only => [:show, :register_save]
  
  def domain_validate
    @firm = validates_firm_with_subdomain do |firm|
      headers["Status"] = "301 Moved Permanently"
      pa = gen_firm_city_path(firm.id)
      redirect_to pa
    end    
  end
  private :domain_validate

  $title_id = 'gs'
  
  # 推广公司编号
  def find_promoted_companies(city)
    promoted_companies = []
    # 只有第一页才推广
    if params[:page].blank? || params[:page] == '1'
      # 收集当前的条件
      selectors = [:price, :model, :district, :order, :style].inject({}) do |h, key|
        h[key] = params[key].to_i unless params[key].to_i == 0
        h
      end
      order = selectors[:order].blank? ? 0 : selectors[:order]
      price = selectors[:price].blank? ? 0 : selectors[:price]
      style = selectors[:style].blank? ? 0 : selectors[:style]
      district = selectors[:district].blank? ? 0 : selectors[:district]
      model = selectors[:model].blank? ? 0 : selectors[:model]
      city = 11910 if city.blank?
      
      #如果没有排序的参数,刚上海默认为1， 其它城市随机
      if order.to_i == 0
        order = city.to_i == 11910 ?  1 : 1 + rand(4)
      end
      # 公司的推广有两种情况：
      # 1. 包含：条件完全符合的，推广
      promoted = PromotedFirm.find_city(city).find_order(order).find_price(price).find_style(style).find_model(model).find_district(district).find_except(0).first
      if !promoted.nil?
        # 为了按指定顺序排序
        promoted.firms_id.each do |id|
          promoted_companies.concat DecoFirm.find :all, :conditions => {:id => id}
        end
      end
      # 2. 排除：只有当条件不符合时，才推广
      promoted_except = PromotedFirm.find_city(city).find_except(1)
      if !promoted_except.blank?
        except_firm_ids = promoted_except.map{ |e| e.firms_id }.flatten
        except = PromotedFirm.find_city(city).find_order(order).find_price(price).find_style(style).find_model(model).find_district(district).find_except(1).first
        except_firm_ids = except_firm_ids - except.firms_id unless except.nil?
        company_except = DecoFirm.find :all, :conditions => {:id => except_firm_ids}
        promoted_companies.concat company_except
      end
    end
    promoted_companies
  end
  private :find_promoted_companies
  
  # 公司列表页
  def index
    @city = params[:city]
    if params[:keyword] && params[:keyword] != ''
      @promoted_companies =  []
      @companies = DecoFirm.paginate :page => params[:page],
        :per_page => 15, 
        :conditions => search_conditions, :order => search_order4
    else    
      params[:order] = '1' if (@city.to_i != 11910) && !params[:style] && !params[:model] && !params[:price] && (params[:order].to_i == 0)
      key = "firms/#{params[:style]}/#{params[:model]}/#{params[:price]}/#{params[:city]}/#{params[:district]}/#{params[:page]}/#{params[:order]}/#{params[:hcase]}/#{params[:hcommont]}/#{params[:is_coupon]}"

      # 先查推荐位上的公司# ==========
      # = Banner =
      # ==========
      @promoted_companies = find_promoted_companies(params[:city])
      # 非推荐位的公司
      @companies = CACHE.fetch(key, RAILS_ENV != 'production' ? 1 : 5.minutes) do
        WillPaginate::Collection.create(params[:page] || 1, 15, nil) do |pager|
          promoted_company_ids = @promoted_companies.map { |c| c.id }
         
          # 是否需要加上次要条件的查询
          # 只有查询条件里面有主打价格、主打装修方式或者主打风格中的一个或者多个才需要次要条件的查询
          need_minor_conditions = [params[:price], params[:model], params[:style]].any? { |p|
            !p.blank? && p != '0'
          }
          # 先用主打价位作为例子，说明一下什么是主要条件和次要条件。
          # 假设用户选择了主打价位为8万以下的装修公司。
          # 那么主打价位属性是8万以下的公司，就是主要条件符合的公司；
          # 主打价位不是8万以下，但是公司的日记中有主打价位为8万以下的日记，这些公司就是次要条件符合的公司。
          #
          # 主要条件符合的合作公司的搜索条件
          major_partner_condition    = search_conditions(promoted_company_ids, DecoFirm, 1)
          # 主要条件符合的非合作公司的搜索条件
          major_nonpartner_condition = search_conditions(promoted_company_ids, DecoFirm, 0)
          # 次要条件符合的合作公司的搜索条件
          minor_partner_condition    = search_conditions(promoted_company_ids, DecorationDiary, 1) if need_minor_conditions
          # 次要条件符合的非合作公司的搜索条件
          minor_nonpartner_condition = search_conditions(promoted_company_ids, DecorationDiary, 0) if need_minor_conditions


          major_partner_count    = DecoFirm.count(:all, :conditions => major_partner_condition)
          major_nonpartner_count = DecoFirm.count(:all, :conditions => major_nonpartner_condition)
          minor_partner_count    = need_minor_conditions ?
            DecoFirm.count(:all,
            :joins => "JOIN decoration_diaries on decoration_diaries.deco_firm_id = deco_firms.id",
            :conditions => minor_partner_condition) : 0
          minor_nonpartner_count = need_minor_conditions ?
            DecoFirm.count(:all,
            :joins => "JOIN decoration_diaries on decoration_diaries.deco_firm_id = deco_firms.id",
            :conditions => minor_nonpartner_condition) : 0
         
          # 先查符合主要条件的合作公司
          offset = major_partner_count - pager.offset
          firms = offset > 0 && DecoFirm.find(:all,
            :conditions => major_partner_condition,
            :order => search_order4,
            :offset => pager.offset,
            :limit => pager.per_page) || []
          
          # 如果符合主要条件的合作公司数量不够，则优先显示符合次要条件的合作公司
          firms.concat(
            DecoFirm.find(
              :all,
              :select => " deco_firms.* ",
              :joins => "JOIN decoration_diaries on decoration_diaries.deco_firm_id = deco_firms.id", 
              :conditions => minor_partner_condition,
              :group => "decoration_diaries.deco_firm_id",
              :order => search_order4,
              :offset => (offset > 0 ? 0 : -offset),
              :limit => (pager.per_page - firms.size)
            )
          ) if firms.size < pager.per_page && need_minor_conditions
           
          # 如果公司数量还不够，优先显示符合主要条件的非合作公司
          if firms.size < pager.per_page
            offset += minor_partner_count
            firms.concat(
              DecoFirm.find(
                :all,
                :conditions => major_nonpartner_condition,
                :order => search_order4(:is_cooperation => :asc),
                :offset => (offset > 0 ? 0 : -offset),
                :limit => (pager.per_page - firms.size)
              )
            )
          end
          
          # 最后用符合次要条件的非合作公司补充
          if firms.size < pager.per_page && need_minor_conditions
            offset += major_nonpartner_count
            firms.concat(
              DecoFirm.find(
                :all,
                :select => " deco_firms.* ",
                :joins => "JOIN decoration_diaries on decoration_diaries.deco_firm_id = deco_firms.id", 
                :conditions => minor_partner_condition,
                :group => "decoration_diaries.deco_firm_id",
                :order => search_order4(:is_cooperation => :asc),
                :offset => (offset > 0 ? 0 : -offset),
                :limit => (pager.per_page - firms.size)
              )
            )

          end
          # 公司排序,保证优先级高的公司排在优先级低的公司前面
          firms = orderd_firms(firms)
          pager.replace firms.uniq
          pager.total_entries = major_partner_count + major_nonpartner_count + minor_partner_count + minor_nonpartner_count
        end
      end
    end
  end
  
  def search_conditions(promoted_company_ids = nil, model = DecoFirm, is_cooperation = nil)
    cond_params = {
      :style => params[:style] != '0' ? params[:style] : nil,
      :model => params[:model] != '0' ? params[:model] : nil,
      :price => params[:price] != '0' ? params[:price] : nil,
      :district => params[:district] != '0' ? params[:district] : nil,
      :keyword => params[:keyword] ? "%#{params[:keyword]}%" : nil,
      :city => params[:city] != '0' ? params[:city] :nil,
      :hcase => params[:hcase] != '0' ? params[:hcase] :nil,
      :hcommont => params[:hcommont] != '0' ? params[:hcommont] :nil,
      :is_cooperation => is_cooperation
    }
    cond_strings = returning([]) do |strings|
      if model == DecoFirm
        strings << "#{model.table_name}.style  = :style" if cond_params[:style]
        strings << "#{model.table_name}.model  = :model" if cond_params[:model]
        strings << "#{model.table_name}.price = :price" if cond_params[:price]
      else
        strings << "#{model.table_name}.style  = :style" if cond_params[:style]
        strings << "#{model.table_name}.model  = :model" if cond_params[:model]
        strings << "#{model.table_name}.price = :price" if cond_params[:price]
        strings << "deco_firms.style  <> :style" if cond_params[:style]
        strings << "deco_firms.model  <> :model" if cond_params[:model]
        strings << "deco_firms.price  <> :price" if cond_params[:price]
        strings << "#{model.table_name}.status  = 1"
      end
      
      strings << "(deco_firms.name_zh like :keyword or deco_firms.name_abbr like :keyword)" if cond_params[:keyword]
      strings << "deco_firms.cases_count > 0" if cond_params[:hcase]
      strings << "deco_firms.comments_count > 0" if cond_params[:hcommont]
      if cond_params[:city].to_i == 11910
        strings << "deco_firms.city = 11910"
        strings << "deco_firms.district = #{cond_params[:district]}" if cond_params[:district]
      elsif cond_params[:city].to_i > 0
        strings << "deco_firms.district = #{cond_params[:city].to_i}"
        strings << "deco_firms.area = #{cond_params[:district]}" if cond_params[:district]
      end
      strings << "deco_firms.state <> -100"
      strings << "deco_firms.id not in (#{promoted_company_ids.join ','})" unless promoted_company_ids.blank?
      if params[:is_coupon] == '1'
        strings << "deco_firms.id in (select distinct deco_events_firms.firm_id from deco_events_firms WHERE event_id in(SELECT id FROM deco_events where starts_at <='#{Time.now.strftime("%Y-%m-%d")}' and ends_at >='#{Time.now.strftime("%Y-%m-%d")}'))"
      elsif params[:is_coupon] == '2'
        strings << "deco_firms.id not in (select distinct deco_events_firms.firm_id from deco_events_firms WHERE event_id in(SELECT id FROM deco_events where starts_at <='#{Time.now.strftime("%Y-%m-%d")}' and ends_at >='#{Time.now.strftime("%Y-%m-%d")}'))"
      end unless params[:is_coupon].blank?

      # -1 为意向公司 0 为创建的新公司非合作  1 合作公司
      if cond_params[:keyword].blank?
        strings << (cond_params[:is_cooperation].to_i == 0 ? "(deco_firms.is_cooperation = -1 or deco_firms.is_cooperation = 0)" : "deco_firms.is_cooperation = #{cond_params[:is_cooperation]}")
      end
      
    end
    cond_strings.any? ? [ cond_strings.join(' and '), cond_params ] : nil
  end
  
  # 正在使用的查询的排序条件
  # 查询合作公司和非合作公司时排序恰好是相反的   合作 is_cooperation DESC  非合作 is_cooperation ASC
  def search_order4(options = {})
    is_cooperation = options[:is_cooperation] || :desc
    order_strings = returning([]) do |strings|
      if params[:order] && (order = COMPANY_SORT_ORDERS[params[:order].to_i])
        strings << "deco_firms.is_cooperation #{is_cooperation}, deco_firms.#{order[0]} desc, deco_firms.praise desc"
      elsif !params[:style] && !params[:model] && !params[:price]
        strings << "deco_firms.is_cooperation #{is_cooperation}, rand()"
      else
        strings << "deco_firms.is_cooperation #{is_cooperation}, praise desc"
      end
    end
    order_strings.any? ? order_strings.join(' , ') : nil
  end
 
  
  # 公司终端页
  def show
    return page_not_found! if ['-100', '-99'].include?(@firm.state)
    city = @firm.city.to_i == 11910 ? @firm.city : @firm.district
    @city_name = TAGURLS[city.to_i]
    # 获取同城市下的6个优惠券
    @promoted_event =  DecoEvent.promoted_events city
    # 获取同城市下的6个不同装修公司的6片装修日记
    @city_diaries = DecorationDiary.firm_diaries city
    # 获取本公司的日记信息
    @firm_diaries = @firm.decoration_diaries
    @diaries = @firm_diaries.paginate :page => params[:page], :per_page => 5
    # 公司施工图片
    @photos = @firm.photos.paginate :page => params[:page], :per_page => 12, :order => "created_at desc"
    # 公司案例图片
    @firm_case_all = Case.firm_case @firm.id
    @firm_case = @firm_case_all.paginate :page => params[:page], :per_page => 12, :order => "LIST_INDEX desc"
    # 设计师
    @designers_all = CaseDesigner.firm_case_designer @firm.id
    @designers = @designers_all.paginate :page => params[:page], :per_page => 4, :order => "LIST_INDEX desc"
    @per_page = 10
    @remarks = @firm.remarks.paginate :page => params[:page], :per_page => @per_page, :order => 'is_essence DESC, created_at desc'
    #在建地工
    @factories = @firm.factories.paginate :page => 1, :per_page => @per_page, :order => 'STARTENABLE desc'
  end
  
  def service
    @firm = DecoFirm.getfirm(params[:id])
    url = get_firm_path @firm
    redirect_301_to url
  end
  
  def promotion
    @firm = DecoFirm.getfirm(params[:id])
    url = get_firm_path @firm
    redirect_301_to url
  end
  
  def detail
    @firm = DecoFirm.getfirm(params[:id])
    url = get_firm_path @firm
    redirect_301_to url
  end

  # 公司简介
  def summary
    @firm = DecoFirm.getfirm(params[:id]) #公司信息
  end
  
  # set_browsed cookies[:browsed_firms]
  def set_browsed_firms
    id = params[:id]
    return unless id
    id = id.to_i
    browsed_firms = (cookies[:browsed_firms] || '').split(',').map(&:to_i)
    browsed_firms.delete id
    browsed_firms.unshift id
    browsed_firms = browsed_firms[0...5] 
    cookies[:browsed_firms] = browsed_firms.join(',')
    true
  end


  # 专题活动需要,去掉form_token的action 2011年1月1日后看到这个aciton可删除
  def register_save2
    url = request.env["HTTP_REFERER"]
    return render :text=>"非法提交" unless url =~ /51hejia/
    new_register = DecoRegister.new(params[:register])
    if new_register.save
      redirect_to "#{url}?success=true"
    else
      redirect_to url
    end
  end
  
  
  
  
  
  def register_save    
    new_register = DecoRegister.new(params[:register])
    if new_register.save
      flash[:notice] = "预约成功！"
      redirect_to request.env["HTTP_REFERER"]
    end 
  end

  # 根据优先级排序
  def orderd_firms(firms)
    unorderd_firms = firms.select{|firm| !firm.priority.blank?}
    return firms if unorderd_firms.size <= 1
    show_firms = firms.dup
    orderd_firms = unorderd_firms.sort_by{|firm| firm.priority}
    unorderd_firms.each_with_index do |unorderd_firm,i|
      show_firms[firms.index(unorderd_firm)] = orderd_firms[i]
    end
    show_firms
  end

  #在建工地分页
  def factory_paginator
    @firm = DecoFirm.getfirm params[:id]
    @per_page = 10
    page = params[:page].nil? ? 2 : params[:page]
    @factories = @firm.factories.paginate :page => page, :per_page => @per_page,:order => 'STARTENABLE desc'
    render :partial => '/firms/factories'
  end
  
  #工装列表页
  def gongzhuang
    @city = params["city"] 
    @city_name = TAGURLS[@city.to_i]
    @page = params[:page] ||= 1
    @per_page = 10
    @alone = true
    @promotes_ids =  CACHE.fetch("gongzhuang_promote_list/#{@city}/#{@page}", RAILS_ENV != 'production' ? 1 : 1.hour) do
      promoted_array = PromotedFirm.find(:first, :conditions => ["city = ? and category = 1", @city.to_i])
      promoted_array && promoted_array.firms_id ? promoted_array.firms_id : []
    end
    @firms = CACHE.fetch("gongzhuang_common_list/#{@city}/#{@page}", RAILS_ENV != 'production' ? 1 : 1.hour) do
      conditions = []
      conditions << (@city.to_i == 11910 ? "city = #{@city.to_i}" : "district = #{@city.to_i}")
      conditions << "state <> '-99' and state <> '-100' and category = 1"
      promotes = []
      promoted_array = PromotedFirm.find(:first, :conditions => ["city = ? and category = 1", @city.to_i])
      if promoted_array && promoted_array.firms_id
        promoted_array.firms_id.each do |id|
          promotes << DecoFirm.find_by_id(id)
        end
      end
      conditions << "id not in (#{promotes.map(&:id).join(',')})" if promotes.size > 0
      companys = DecoFirm.find(:all,:conditions => conditions.join(' and '),:order => "is_cooperation DESC , praise desc")
      (promotes + companys).paginate(:page => @page, :per_page => @per_pag)
    end
    render "/firms/index"
  end
  
  #别墅列表页
  def bieshu
    @page = params[:page] ||= 1
    @per_page = 10
    @alone = true
    @city = params["city"]
    @city_name = TAGURLS[@city.to_i]
    @promotes_ids =  CACHE.fetch("bieshu_promote_list/#{@city}/#{@page}", RAILS_ENV != 'production' ? 1 : 1.hour) do
      promoted_array = PromotedFirm.find(:first, :conditions => ["city=? and villa=1",@city.to_i])
      promoted_array && promoted_array.firms_id ? promoted_array.firms_id : []
    end

    @firms = CACHE.fetch("bieshu_common_list/#{@city}/#{@page}", RAILS_ENV != 'production' ? 1 : 1.hour) do
      conditions = []
      conditions << (@city.to_i == 11910 ? "city = #{@city.to_i}" : "district = #{@city.to_i}")
      conditions << "state <> '-99' and state <> '-100' and villa = 1"
      promotes = []
      promoted_array = PromotedFirm.find(:first, :conditions => ["city=? and villa=1",@city.to_i])
      if promoted_array && promoted_array.firms_id
        promoted_array.firms_id.each do |id|
          promotes << DecoFirm.find_by_id(id)
        end
      end
      conditions << "id not in (#{promotes.map(&:id).join(',')})" if promotes.size > 0
      companys = DecoFirm.find(:all,:conditions => conditions.join(' and '),:order => "is_cooperation DESC , praise desc")
      @firms = (promotes + companys).paginate(:page => @page, :per_page => @per_pag)
    end
    render "/firms/index"
  end

end
