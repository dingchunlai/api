class DecoController < ApplicationController

  before_filter :city_validate

  def city_validate
#    @coi = get_and_save_city3(nil,request.remote_ip)
    @subdomain = request.subdomains.to_s
    if @subdomain.include?("shanghai")
      @city_code = 'UA-12518263-1'
      @recity = 54008
      @user_city_code = '11910'
    elsif @subdomain.include?("suzhou")
      @city_code = 'UA-12518279-2'
      @recity = 54919
      @user_city_code = '12117'
    elsif @subdomain.include?("ningbo")
      @city_code = 'UA-12518326-3'
      @recity = 54917
      @user_city_code = '12301'
    elsif @subdomain.include?("hangzhou")
      @city_code = 'UA-12518326-2'
      @recity = 54916
      @user_city_code = '12306'
    elsif @subdomain.include?("wuxi")
      @city_code = 'UA-12518279-3'
      @recity = 54918
      @user_city_code = '12118'
    else
#      @city_code = 'UA-12518263-1'
#      @recity = 54008
#      @user_city_code = '11910'
    end
      params[:city] = @user_city_code # 兼容旧版本，原有逻辑是通过params[:city]来判断当前访问的城市
      cookies[:user_city] = {:value => @user_city_code, :domain=>".51hejia.com",:expires => 1.years.from_now} if @recity.to_i > 0
  end

  def index
    render :layout => false
  end

  def zhuanti_picture_upload
    file = params[:pages][:uploaded_data]
    title = params[:pages][:title]

    filename = uploadImage(file,'')

    save_path = "/images/binary/"
    @insertString = "<span><img src=\"#{save_path}#{filename}\" alt=\"#{title}\" onload=\"if(width>500)width=500\"/></span>"
    session[:item] = save_path+filename
    s = session[:item]
    render :layout => false
  end
  #上传文件相关
  def getFileName(file)
    Time.now.strftime("%Y%m%d").to_s+Time.now.to_i.to_s+file.original_filename
  end
  def uploadImage(file,fname)
    if fname && fname != ''
      filename=fname
    else
      filename=getFileName(file)
    end

    File.delete("#{RAILS_ROOT}/public/images/binary/#{filename}") if File.exist?("#{RAILS_ROOT}/public/images/binary/#{filename}")
    File.open("#{RAILS_ROOT}/public/images/binary/#{filename}", "wb") do |f|
      f.write(file.read)
    end

    return filename

  end

  def get_city
    @city = get_and_save_city(nil,request.remote_ip)
    render :partial => "get_city"
  end

  def google_map
    if params[:lat].to_i != 0 && params[:lng].to_i != 0
      @map = GoogleMap::Map.new
      @map.controls = [ :zoom ]
      @map.zoom = 15
      @map.markers << GoogleMap::Marker.new(  :map => @map,
                                          :lat => params[:lat].to_f,
                                          :lng => params[:lng].to_f)
    end
    render :layout => false
  end

  #新首页上公司显示
  def index_firm
    render :layout => 'none'
  end


  def index_rewrite
    #以前访问过,跳转
    city_code = get_and_save_city2(nil, request.remote_ip).to_i
    case city_code
    when 12117
      redirect_to 'http://z.suzhou.51hejia.com/'
    when 12301
      redirect_to 'http://z.ningbo.51hejia.com/'
    when 12306
      redirect_to 'http://z.hangzhou.51hejia.com/'
    when 12118
      redirect_to 'http://z.wuxi.51hejia.com/'
    when 11910
      redirect_to 'http://z.shanghai.51hejia.com/'
    else
      @cityname = '上海'
      @cityurl = 'http://z.shanghai.51hejia.com/'
      render :layout => 'none'
    end
  end
end
