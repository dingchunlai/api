class WorksitesController < DecoController
  #工地列表
  def index
    if params[:firm_id]
      companyid = params[:firm_id]
    else
      companyid = params[:id]
    end
    
    #公司信息
    @company = DecoFirm.getfirm(companyid)
    
    key = "zhaozhuangxiu_worksites_#{companyid}_#{params[:page] ||= 1}_#{Time.now.strftime('%Y%m%d%H')}"
    CaseFactoryCompany
    CaseTag
    if CACHE.get(key).nil?
      #在建工地
      @factories = CaseFactoryCompany.find(:all, :conditions => "COMPANYID = '#{companyid}'",:order => "ID desc",:include => [:tagc])
      @factories = @factories.paginate :page => params[:page], :per_page => 20
      CACHE.set(key,@factories)
    else
      @factories = CACHE.get(key)
    end
  end
  
end
