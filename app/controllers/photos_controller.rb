class PhotosController < DecoController
  include DecoHelper
  before_filter :domain_validate,:only => :index
  
  def domain_validate
    @firm = validates_firm_with_subdomain(:firm_id) do |firm|
      headers["Status"] = "301 Moved Permanently" 
      redirect_to gen_firm_city_photos(firm.id)
    end    
  end
  private :domain_validate

  def index
    @type = params[:type]
    if params[:firm_id]
      @firm = DecoFirm.find(params[:firm_id])
      @photos = @firm.photos.paginate :page => params[:page], :per_page => 24, :order => "created_at desc"
    else
      @photos = DecoPhoto.paginate :page => params[:page], :per_page => 24, :order => "created_at desc"
    end
  end

  def slide
    if params[:firm_id]
      @firm = DecoFirm.find(params[:firm_id])
      @photos = @firm.photos.paginate :page => params[:page], :per_page => 24, :order => "created_at desc"
    else
      @photos = DecoPhoto.paginate :page => params[:page], :per_page => 24, :order => "created_at desc"
    end
  end
  
  def paginator
    firm = DecoFirm.find params[:id] 
    @photos = firm.photos.paginate :page => params[:page], :per_page => 12, :order => "created_at desc"
    render :partial => '/firms/photos'
  end
end
