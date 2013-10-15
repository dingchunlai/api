class RemarksController < DecoController
  before_filter FormTokenFilter, :only => [:save, :firm_remark_save]
  helper :firms
  def paginator
    @firm = DecoFirm.getfirm params[:id]
    @per_page = 10
    page = params[:page].nil? ? 2 : params[:page]
    @remarks = @firm.remarks.paginate :page => page, :per_page => @per_page, :order => 'is_essence DESC, created_at desc'
    render :partial => '/firms/remarks'
  end
  
  # 公司评论信息保存页面
  def firm_remark_save
    @remark = Remark.new(params[:remark])
    @remark.created_at = Time.now
    @remark.resource_type='DecoFirm'
    @remark.ip=request.remote_ip
    @remark.user_id = current_user.USERBBSID
    mark = params[:mark_tj] #判断是否打分  :mark_tj = 1 为打分
    firm_id = @remark.resource_id
    this_mobile = params[:this_mobile]
    is_mark = (!mark.nil? || !mark.blank?) && mark.to_i == 1 ? true : false
    if !@remark.praise.blank?
      if is_mark
        if !@remark.praise.blank?
          @remark.praise = @remark.praise.to_i
          if params[:zuimanyi] && params[:jiaomanyi]
            if params[:zuimanyi]
              if params[:zuimanyi] == "设计"
                @remark.design_praise = 10
              elsif params[:zuimanyi] ==  "施工"
                @remark.construction_praise = 10
              elsif params[:zuimanyi] == "服务"
                @remark.service_praise = 10
              end
            end
            if params[:jiaomanyi]
              if params[:jiaomanyi] == "设计"
                @remark.design_praise = 9
              elsif params[:jiaomanyi] ==  "施工"
                @remark.construction_praise = 9
              elsif params[:jiaomanyi] == "服务"
                @remark.service_praise = 9
              end
            end
            @remark.design_praise = 8 if @remark.design_praise == 0
            @remark.construction_praise = 8 if @remark.construction_praise == 0
            @remark.service_praise = 8 if @remark.service_praise == 0
          elsif params[:zuimanyi] && !params[:jiaomanyi]
            if params[:zuimanyi] == "设计"
              @remark.design_praise = 10
            elsif params[:zuimanyi] ==  "施工"
              @remark.construction_praise = 10
            elsif params[:zuimanyi] == "服务"
              @remark.service_praise = 10
            end
          elsif !params[:zuimanyi] && params[:jiaomanyi]
            if params[:jiaomanyi] == "设计"
              @remark.design_praise = 9
            elsif params[:jiaomanyi] ==  "施工"
              @remark.construction_praise = 9
            elsif params[:jiaomanyi] == "服务"
              @remark.service_praise = 9
            end
          end
        end
        current_user.update_attributes(:USERBBSMOBELTELEPHONE => this_mobile ,:mobile_verified => 1) unless current_user.mobile_verified
      else
        @remark.praise = @remark.design_praise = @remark.construction_praise = @remark.service_praise = nil  #如果不打分，则为空
      end
    end
    if !(!PublicModule.remark_mark_verify(current_user.id ) && is_mark )
      if @remark.save
        PublicModule.add_remark_mark(current_user.id ) if (is_mark && !@remark.praise.blank?)
        redirect_to(:controller => :firms, :action => :show, :id => firm_id)
      else
        flash[:error] = "您在一分钟内，不能频繁发表多次评论!"
        redirect_to(:controller => :firms, :action => :show, :id => firm_id)
      end
    else
      flash[:error] = "提示：对不起.您6个月只能评论一次"
      redirect_to(:controller => :firms, :action => :show, :id => firm_id)
    end
    
    
  end
  
  # 优惠券评论信息页面
  def save
    remark = Remark.new
    remark.content = params[:remark][:content]
    remark.resource_id = params[:event_id]
    remark.resource_type = "DecoEvent"
    remark.ip = request.remote_ip
    remark.user_id = current_user.USERBBSID
    unless remark.save
      flash[:error] = "提示：您在一分钟内，不能频繁发表多次评论!"
    end
    redirect_to request.env["HTTP_REFERER"]
  end
  
end

