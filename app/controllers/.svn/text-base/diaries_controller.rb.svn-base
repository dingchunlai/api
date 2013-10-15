class DiariesController < DecoController

  def index
    if params[:firm_id]
      @firm = DecoFirm.find(params[:firm_id])
      @diaries = @firm.diaries.paginate :page => params[:page], :per_page => 18, :order => "created_at desc"
    else
      @diaries = DecoDiary.paginate :page => params[:page], :per_page => 18, :order => "created_at desc"
    end
  end
end
