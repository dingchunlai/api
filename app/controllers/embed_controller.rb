class EmbedController < ApplicationController
  
  layout false
  before_filter :validate_firm , :only => ["index"]
  
  def index
    # 获取本公司的日记信息
    @diaries = DecorationDiary.get_firm_diaries(@firm.id,3)
    #在建地工
    @factories = @firm.factories.paginate :page => 1, :per_page => 8, :order => 'STARTENABLE desc'
    #留言 
    @remarks = @firm.remarks.paginate :page => 1, :per_page => 3, :order => 'is_essence DESC, created_at desc'
    # 设计师
    @designers_all = CaseDesigner.firm_case_designer @firm.id
    @designers = @designers_all.paginate :page => params[:page], :per_page => 2, :order => "LIST_INDEX"
  end
  
  
  #设计师翻页
  def designers_page
    @firm = DecoFirm.getfirm params[:id]
    @designers_all = CaseDesigner.firm_case_designer @firm.id
    @designers = @designers_all.paginate :page => params[:page], :per_page => 2, :order => "LIST_INDEX"
    render :partial => "/embed/designers"
  end
  
  #留言翻页
  def remark_page
    @firm = DecoFirm.getfirm params[:id]
    page = params[:page].nil? ? 2 : params[:page]
    @remarks = @firm.remarks.paginate :page => page, :per_page => 3, :order => 'is_essence DESC, created_at desc'
    render :partial => "/embed/remark"
  end
  
  private
  def validate_firm
    name_zh = params[:name]
    @firm = DecoFirm.get_firm_by_name(name_zh)
    if @firm.nil?
      page_not_found!
      false
    end
  end
  
end