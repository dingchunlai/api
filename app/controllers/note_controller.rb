class NoteController < DecoController

  before_filter :get_browsed_diaries, :only => [:list]

  def list
    @page = params[:page] ||= 1
    @method = params[:method]
    @style = params[:style]
    @price = params[:price]
    @room = params[:room]
    @myorder = params[:myorder]
    @alltype = params[:alltype]
    @title = (params[:title] && params[:title] != '0') ? params[:title] : ''
    @city_id = get_and_save_city(nil, request.remote_ip)

    if @page == 1 || @page == '1'
      # 由于日记页面的装修方式的参数为method，所以我们添加model参数到现有的参数中，为了和公司推广的参数一致
      params[:model] = params[:method]
      # 日记列表现有的几个查询条件
      selectors = [:price, :model, :order, :style].inject({}) do |h, key|
        h[key] = params[key].to_i unless params[key].to_i == 0
        h
      end
      # 将params[:order]添加到参数集合中，为了和公司推广一致
      if !selectors.blank?
        selectors[:order] = params[:order] = 1
      end
      city = TAGURLS[@city_id.to_i]
      city = 'shanghai' if city.blank?
      # 公司的推广有两种情况：
      # 1. 包含：条件完全符合的，推广
      company = PROMOTED_COMPANIES[city][:only].find { |k, v| selectors == k }
      promoted_company_ids = company && company[1].dup || []
      # 2. 排除：只有当条件不符合时，才推广
      (PROMOTED_COMPANIES[city][:except] || {}).each do |condition, company_ids|
        promoted_company_ids.concat company_ids unless condition == selectors
      end
      promoted_company_ids = [] if city == 'hangzhou'
      # 当推广公司不为空时
      unless promoted_company_ids.blank?
        @promoted_note = []
        promoted_company_ids.collect{ |firm_id|
          @promoted_note << DecorationDiary.find(
            :first,
            :select => "decoration_diaries.*",
            :joins => "join deco_firms as firm on firm.id = decoration_diaries.deco_firm_id ",
            :conditions => ["decoration_diaries.status = ? and firm.id = ? ", 1, firm_id],
            :order => 'decoration_diaries.id desc'
          )
        }
      end
    end
    key = "notes/list/#{@city_id}/#{@method}/#{@style}/#{@price}/#{@room}/#{@myorder}/#{@alltype}/#{@myorder}/#{@page}/#{@title}"
    DecorationDiary
    Picture
    @note = CACHE.fetch(key, RAILS_ENV == 'production' ? 1.hour : 0) do
      @city = CaseTag.find(@city_id.to_i) if !@city_id.nil? && @city_id != 0
      conditions = []
      conditions << "decoration_diaries.status = 1"
      conditions << "decoration_diaries.model = #{@method}" if @method && @method != '0'
      conditions << "decoration_diaries.style = #{@style}" if @style && @style != '0'
      conditions << "decoration_diaries.price = #{@price}" if @price && @price != '0'
      #      conditions << "photo.stage = #{@stage}" if @stage && @stage != '0'
      conditions << "decoration_diaries.room = #{@room}" if @room && @room != '0'
      conditions << "decoration_diaries.title like '%#{params[:title]}%'" if params[:title] && params[:title] != '0'
      conditions << (@city_id.to_i == 11910 ? "firm.city = #{@city_id}" : "firm.district = #{@city_id}")
      if @myorder=='0'  #精华
        conditions << "decoration_diaries.is_good = 1"
      elsif @myorder=='2' #普通
        conditions << "decoration_diaries.is_good = 0"
      end
      # 为了将推广公司的其中一片日记排除掉
      conditions << "decoration_diaries.id not in (#{@promoted_note.map(&:id)})" unless @promoted_note.blank?
      DecorationDiary.paginate(
        :all,
        :select => "decoration_diaries.*",
        :joins => "join deco_firms as firm on firm.id = decoration_diaries.deco_firm_id ",
        :conditions => conditions.join(' and '),
        :page => @page,
        :per_page => 8,
        :group => 'decoration_diaries.id',
        :order => 'decoration_diaries.created_at desc'
      )
    end
  end

end
